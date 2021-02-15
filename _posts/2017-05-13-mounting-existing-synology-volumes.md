---
date: 2017-05-13
title: Mounting old Synology volumes in new hardware
tags:
  - Synology
  - Linux
category: Home Lab
---

I recently upgraded my Synology NAS from a DS 214play that I've had for a few
years to a DS 1515+, and bought two additional drives to go along with it. I
also wanted to do a fresh start of the configuration and metadata, as I had been
having some issues with my existing NAS (in addition to the performance issues
that drove me to upgrade), so I did not want to just move the existing drives
over and add the new ones to the same array.

I set up the 1515+, and started copying files over using SFTP mounts--however, I
was getting abysmal speeds, 10-11 MB/s at best. Both pieces of hardware were
connected to a gigabit network, neither was doing anything else at the time, but
transfers were incredibly slow. Not wanting to wait a few days to transfer 3 TB
of data, I set out to find a better way to transfer.

I knew Synology's "Hybrid RAID" was just a Linux software RAID, which meant I
should be able to mount it in the new Synology as well. I started by doing some
exploring with mdadm, checking that the array was not degraded for some reason,
etc. However, I couldn't simply assemble it and mount it&mdash;under the
software RAID is an LVM volume group. I started by dumping some state about the
volume groups:

{% gist bojanrajkovic/a03f947781b809b5848feb1171f51b7c vgdisplay.log %}

Aha! `vgdisplay` is telling me what I want to know already: I have a duplicate
volume group, and the existing one that was created here (the new NAS's VG) is
taking precedence over the old one. Armed with the UUID there, I can rename the
old VG:

{% gist bojanrajkovic/a03f947781b809b5848feb1171f51b7c vgrename.log %}

Once it's been renamed, the next step is to activate the VG so that it gets a
/dev entry and becomes mountable:

{% gist bojanrajkovic/a03f947781b809b5848feb1171f51b7c vgchange.log %}

Once we've activated it, we can mount it via its /dev entry, and we can see our
entire main storage volume there:

{% gist bojanrajkovic/a03f947781b809b5848feb1171f51b7c mount.log %}

Once the volume group was mounted, I could copy files much faster than copying
over the network allowed me&mdash;100+ MB/s vs. 10-11.

Important notes:

* None of these operations should cause data loss, but I am not responsible for
  any data loss that may occur if you follow my instructions!
* Be careful when copying the UUID for a rename.
* More complex Synology setups may not work this easily&mdash;I did everything
  assuming you set up a single volume group, all the drives are in the same RAID
  array, etc.
  * That said, you should be able to use these same tools on more complex
    setups, just with more care taken to find the right volume groups.
* I had to reboot to get the drives back into a state where I could erase them
  and add them to an existing volume.
* I would suggest **not** rebooting your Synology with the old drives plugged
  in&mdash;it is likely to pick up the old volume as a new volume and re-shuffle
  your volumes and shared folders.
* These instructions should work on anything that supports LVM/mdraid and the
  filesystem on the drives (ext4 or btrfs).

Good luck!
