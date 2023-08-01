---
published: true
created: 2023-07-31
date: 2023-07-31
title: Automate the Docker DNS Pain Away
tags:
  - docker
  - dns
category: Infrastructure
excerpt: >-
  Making progress from an infuriating, half-broken Docker DNS setup, to
  one that works reliably with some existing tools, and only mild cursing.
---

Like many other nerds, I have somewhat of a homelab at home. These days it's not as complicated as it used to be, consisting largely of a big "NAS"[^0], a Home Assistant box, and a couple other small things.

The NAS, being a beefy server machine, runs a bunch of Docker containers for various things — Octoprint, Docspell (which runs 2 of its own containers + Solr), etc.. It also runs NixOS[^1], and all of these containers are fronted by the [Let's Encrypt](https://nixos.wiki/wiki/ACME) and [Nginx](https://nixos.wiki/wiki/Nginx) infrastructure that it provides. To avoid exposing ports on the NAS's "host" network, I point Nginx virtual hosts directly at container IPs, like so:

```js
services.nginx.virtualHosts."octoprint.coderinserepeat.com" = {
  enableACME = true;
  acmeRoot = null;
  forceSSL = true;
  locations."/" = {
	proxyPass = "http://10.0.1.1:80";
	proxyWebsockets = true;
	extraConfig = "client_max_body_size 0;";
  };
};
```

This generally works, except...one of the things that NixOS does as part of a `nixos-rebuild --switch` when using the declarative Nginx configuration is an Nginx configuration check. Normally, this is great: if I screw up the configuration somehow (e.g. injecting some bad configuration), it won't take down Nginx. However, it has a big downside: if containers are restarted/container configuration changes, assigned IPs are not stable[^2], and Nginx configuration will fail to validate.

Previously, I'd tried a number of things that purported to provide a Docker <-> DNS translation, subscribing to Docker daemon events and running a DNS server that I could point other things at. In practice, this never worked quite right: despite telling `systemd-resolved` that the `dns-proxy-server` container should be used for DNS, rebuilds (and thus Nginx config checks) would frequently fail because the upstreams would fail to respond on the `proxyPass` ports.

I was about to embark on a "stupid scratch a homelab itch" project and write something that connects to Docker, listens for events, and updates Route53[^3], when [Pete Keen](https://hachyderm.io/@zrail) suggested that I check out the [`docker-gen`](https://github.com/nginx-proxy/docker-gen/) project, and then pointed me at [`dnscontrol`](https://dnscontrol.org/) as well. Sensing an opportunity to hit a Pareto optimal[^4], I set about hacking up some `systemd` services and a `dnsconfig.js.tmpl` file, and an hour or so later, had something extremely feasible.

For the purposes of this writeup, I'm going to assume that you already have the `dnscontrol` and `docker-gen` binaries somewhere on your system. In my case, they're in `/nas/homes/brajkovic/bin`. I also assume that you're using Nix/NixOS, because I didn't write the units manually, but hopefully these declarations for the `systemd` units are simple enough to manually write the full unit.

## The `systemd` units

### `docker-gen`

First, the `docker-gen` unit — `docker-gen` knows how to run as a daemon and listen to events, so we can run it as a normal `systemd` service:

```js
systemd.services."docker-gen-dns" = {
  path = [
    "/nas/homes/brajkovic/bin"
  ];

  script = ''
    docker-gen -config docker-gen.cfg
  '';

  serviceConfig.WorkingDirectory = "/nas/homes/brajkovic/.config/dns";
  wantedBy = [ "multi-user.target" ];
};
```

The working directory is where the `docker-gen.cfg` file lives, it'll be in the next section.

### `dnscontrol`

Next, the `dnscontrol` unit — in this case, we register it as a `oneshot` unit, because `docker-gen` will run `systemd` to start it.

```js
systemd.services."dnscontrol-apply-docker.coderinserepeat.com" = {
  path = [
    "/nas/homes/brajkovic/bin"
  ];

  script = ''
    dnscontrol version
    dnscontrol preview
    dnscontrol push
  '';

  serviceConfig.Type = "oneshot";
  serviceConfig.WorkingDirectory = "/nas/homes/brajkovic/.config/dns";
  after = [ "multi-user.target" ];
};
```

## The config files

### `docker-gen.cfg`

This file configures `docker-gen`'s behavior, and is super simple:

```toml
[[config]]
dest = "dnsconfig.js"
notifycmd = "systemctl start dnscontrol-apply-docker.coderinserepeat.com"
template = "dnsconfig.js.tmpl"
watch = true
wait = "500ms:2s"
```

It tells `docker-gen` to source the template from `dnsconfig.js.tmpl`, write it to `dnsconfig.js`, and then run our `dnscontrol` unit as the "notify" command after it's done updating the template. Setting `watch` to `true` puts `docker-gen` in daemon mode, and `wait` configures the hysteresis: it will wait at least 500ms, at most 2 seconds, to debounce changes.

### `dnsconfig.js.tmpl`

The `dnscontrol` template, also deceptively simple:

```js
var REG_NONE = NewRegistrar("none");
var DSP_R53 = NewDnsProvider("r53_main");

D("docker.coderinserepeat.com", REG_NONE, DnsProvider(DSP_R53),{% raw %}
{{range $key, $value := .}}
    {{if $value.IP}}
    // {{ $value.Name }} ({{$value.ID}} from {{$value.Image.Repository}})
    A("{{ $value.Name }}", "{{$value.IP}}"),
    {{end}}
{{end}}{% endraw %}
    // Allow letsencrypt to issue certificate for this domain
    CAA("@", "issue", "letsencrypt.org"),
    // Allow ACM to issue certificates for this domain
    CAA("@", "issue", "amazon.com"),
    // Allow no CA to issue wildcard certificate for this domain
    CAA("@", "issuewild", ";"),
    // Report all violation to test@example.com. If CA does not support
    // this record then refuse to issue any certificate
    CAA("@", "iodef", "mailto:caa@coderinserepeat.com", CAA_CRITICAL)
)
```

This is mostly basic JavaScript, plus some Go template language — we emit all the `A` records for the Docker images, and some really basic `CAA` records so that we can issue certs if we need to for those DNS names[^5].

### `creds.json`

The basic "credentials" file for `dnscontrol`:

```json
{
  "r53_main": {
    "TYPE": "ROUTE53"
  }
}
```

This doesn't actually have any credentials, because those are provided by the standard AWS SDK credentials mechanism — I should probably do something better with those secrets, but if you can either log into or physically steal my NAS, you've earned my AWS creds.

## Wrapping It All Up

Putting all that together, we're *done*. The `docker-gen` daemon runs, supervised by its `systemd` unit. When it needs to, it spawns `dnscontrol`, but it mostly just sits there idly — I had to restart it to get any recent output, and it said:

```
Jul 31 22:32:58 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:32:58 Watching docker events
Jul 31 22:32:58 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:32:58 Contents of dnsconfig.js did not change. Skipping notification 'systemctl start dnscontrol-apply-docker.coderinsepeat.com'
```

When I manually killed a container[^6], you can see the expected output when things do happen:

```
Jul 31 22:35:09 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:35:09 Received event die for container 236c84adea38
Jul 31 22:35:10 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:35:10 Debounce minTimer fired
Jul 31 22:35:10 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:35:10 Received event stop for container 236c84adea38
Jul 31 22:35:10 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:35:10 Generated 'dnsconfig.js' from 7 containers
Jul 31 22:35:10 hagal docker-gen-dns-start[3691698]: 2023/07/31 22:35:10 Running 'systemctl start dnscontrol-apply-docker.coderinserepeat.com'
```

The unit was indeed started, and you can see `dnscontrol` applies the changes:

```
Jul 31 22:35:11 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: [INFO: Diff2 algorithm in use. Welcome to the future!]
Jul 31 22:35:11 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: ******************** Domain: docker.coderinserepeat.com
Jul 31 22:35:12 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: 1 correction (r53_main)
Jul 31 22:35:12 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: #1: - DELETE dns-proxy-server.docker.coderinserepeat.com A 10.0.0.4 ttl=300
Jul 31 22:35:12 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: SUCCESS!
Jul 31 22:35:12 hagal dnscontrol-apply-docker.coderinserepeat.com-start[3712349]: Done. 1 corrections.
```

Overall, really simple, and like I said, hits a strong Pareto optimal: an all-in-one solution would be cool, but bodging together some existing tools and a few `systemd` services provided satisfying short-term relief.

[^0]: A Supermicro 6028U-TR4T+, with dual Xeon E5-2650L v3 processors, 128 GB of RAM, and all the disks I could cram in. I expect it to last me…a damn long time.
[^1]: Which was in some ways a mistake, and in some ways really speeds things along.
[^2]: Manually managing IPAM for Docker containers is not my idea of a good time: see the aforementioned mild regret of using NixOS — I don't actually want to spend that much sysadmin time.
[^3]: Where my domain is hosted, but likely it would have ended up supporting pluggable providers, because I can't build anything without overbuilding it.
[^4]: 80% of the desired outcome, 20% of the work.
[^5]: Not that we need to — the day-to-day records that I use live on the root domain.
[^6]: Just for fun, but I do need to cut this container out of the configuration for good.