---
title: 'Chef, Knife, AWS, and Windows: Part 1'
date: '2015-07-15 18:32:41'
tags:
- Windows
- Chef
- Configuration Management
- EC2
- Knife
category: DevOps
---

UPDATE #2: Also see [Part 3][1], which slims down the scripting a bit by
removing the password reset requirement.

UPDATE: See [Part 2][0] for some additional info on getting `knife-ec2` to work
correctly when associating public IPs and launching into a VPC.

There's a lot of incomplete advice out there regarding using Chef, `knife-ec2`,
and `knife-windows` to provision Windows machines automatically. Most
critically, it fails to mention which *versions* of Windows it works with. In
all likelihood, it only works with Windows 2008, and maybe Windows 2012, but not
2012 R2. The latter introduced some new security features, especially around the
WinRM service that `knife` uses to bootstrap Windows machines.

After spending somewhere between 8 and 10 total hours getting it working, here's
the steps I followed. I used Ubuntu 14.04.2 LTS as my "control" box, sitting in
EC2 in the same VPC as the server being created to minimize roundtrip lag and
avoid mucking with security groups too much. You may have to adjust the steps
slightly if you're launching into EC2-Classic, or from outside the VPC&mdash;if
anyone has adjustments/feedback, please leave them in the comments and I'll try
and incorporate them into the post.

1. Install Ruby 2.0: `sudo apt-get install ruby2.0`. We need this for the most
   recent Chef version&mdash;it depends on a recent version of `ohai`, and
   `ohai` depends on Ruby 2.x+. If you already have Ruby 2.x+, skip this step.
   If you had Ruby 1.9 installed, be aware that Debuntu Ruby packaging had a
   brainfart that was fixed in versions after 14.04.2, and installing the
   `ruby2.0` package won't overwrite `/usr/bin/ruby` with your new Ruby, causing
   Chef and `ohai` to fail installing mysteriously. If you find that `ruby
   --version` after installing `ruby2.0` doesn't read 2.0, you'll need to run
   the following, as root:

   ```bash
   # Rename original out of the way, so updates / reinstalls don't squash our hack fix
   dpkg-divert --add --rename --divert /usr/bin/ruby.divert /usr/bin/ruby
   dpkg-divert --add --rename --divert /usr/bin/gem.divert /usr/bin/gem
   # Create an alternatives entry pointing ruby -> ruby2.0
   update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby2.0 1
   update-alternatives --install /usr/bin/gem gem /usr/bin/gem2.0 1
   ```

2. Install Chef, `knife-ec2`, and `knife-windows`: `gem install chef knife-ec2
   knife-windows`. This may take a little while (though not nearly as long as
   installing Berkshelf).
3. Write a bit of Powershell that we'll add as the user data for our instance.
   Most of this is taken verbatim from older guides, but some new steps are
   introduced to make it work on Server 2012 R2. Write this to a file somewhere,
   and remember its path&mdash;you'll need to give it to Knife in the next step:

   ```powershell
   <powershell>
   # Set our admin password
   $admin = [adsi]("WinNT://./Administrator, user")
   $admin.psbase.invoke("SetPassword", "Ch4ng3m3")
   # Turn on WinRM, make sure to relax its security a bit.
   # Please don't expose the WinRM port to the world on these machines.
   # I am not responsible for anything that happens if you do.
   winrm qc -q
   winrm set winrm/config '@{MaxTimeoutms="1800000"}'
   winrm set winrm/config/service '@{AllowUnencrypted="true"}'
   winrm set winrm/config/service/auth '@{Basic="true"}'
   # Make sure to trust all hosts
   Set-Item wsman:localhost\client\trustedhosts -value * -force
   # Turn off the Windows firewall. Its default WinRM rules only allow traffic from
   # hosts in your domain and from "private" networks. Its functionality is superseded
   # by security groups anyway.
   Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False
   # Stop the WinRM service, make sure it autostarts on reboot, and start it
   net stop winrm
   sc.exe config winrm start=auto
   net start winrm
   </powershell>
   ```

4. Configure the WinRM port in `knife.rb`. For some reason, this doesn't seem to
   get passed on the command line. Add the following to your `knife.rb` (5985 is
   the default plaintext WinRM port):

   ```ruby
   knife[:winrm_port] = 5985
   ```

5. Use `knife-ec2` to start up the server. This invocation is for VPC, you
   should read the documentation and adjust the flags for your environment as
   appropriate:

   ```shell
   knife ec2 server create \
       --node-name <YOUR NODE NAME> # e.g. Foo
       --ebs-size <EBS VOLUME SIZE IN GB> # e.g. 40
       --flavor <INSTANCE TYPE> # e.g. t2.medium
       --region <REGION> # e.g. us-east-1
       --subnet <VPC SUBNET> # e.g subnet-deadbeef
       --image <AMI ID> # e.g. ami-5b9e6b30, corresponding to the latest Server 2012 R2 RTM image in us-east-1
       --security-group-ids <SG LIST> # e.g. sg-deadbeef,sg-beefbeef -- the list must be comma-separated
       -A <AWS_ACCESS_KEY>
       -K <AWS_SECRET_KEY>
       --ssh-key <KEY NAME> # must correspond to a .pem file in ~/.ssh/
       --user-data <PATH TO USERDATA FILE FROM STEP 3>
       --winrm-user Administrator
       --winrm-password <PASSWORD FROM USERDATA FILE>
       --winrm-transport plaintext
       --associate-public-ip # Without a public IP, bootstrap can't download the Chef client
   ```

6. Wait! After about 20 minutes or so, you should have a mountain of output from
   Knife and a bootstrapped Windows machine registered with your Chef server.
   Now you can customize its run list, assign an environment, a role, etc. To
   run `chef-client` to pull the new configuration, you can use something like
   this: `knife winrm <SERVER IP> 'chef-client -c c:/chef/client.rb' -m -x
   Administrator -P <PASSWORD FROM STEP 3>`. You can also use `knife` to query
   information from your nodes -- see the documentation at
   https://github.com/chef/knife-windows for some of the things you can do.

There's definitely more to investigate here. For one, it looks like `knife-ec2`
knows how to get the Windows password from EC2, so we may be able to skip the
`--winrm-user` and `--winrm-password` parameters entirely (as well as the
password reset in the Powershell script). If I find anything new, I'll update
this post or post something new and link to it from here.

[0]: http://blog.coderinserepeat.com/2015/07/15/chef-knife-and-windows-part-2/
[1]: http://blog.coderinserepeat.com/2015/07/16/chef-knife-aws-and-windows-part-3/
