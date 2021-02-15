---
title: 'Chef, Knife, AWS, and Windows: Part 2'
date: '2015-07-15 21:55:55'
tags:
- Windows
- Chef
- Configuration Management
- EC2
- Knife
- AWS
category: DevOps
---

Update: [Part 3][1] removes the need for explicit password setting!

In [Part 1][0] of this series of blog posts, I started working on getting
`knife-ec2` to bootstrap Windows machines for me and connect them to a Hosted
Chef server. My steps _mostly_ worked, but I realized after running them that I
had made one critical mistake: I assumed that associating a public IP after the
fact and running bootstrap would have the same effect as simply associating the
public IP from the beginning. This was wrong.

In my initial run, I didn't pass `--associate-public-ip` to `knife-ec2` -- as it
turns out, you *do* need a public IP to do, well, most things (including things
like downloading the Chef client, which is pretty important ;-). I had simply
associated an IP afterwards and bootstrapped the machine, thinking it would work
the same. However, `knife-ec2` seems to look in the wrong variables when it
tries to retrieve the address for the newly created VPC instance, causing
bootstrapping to fail when a public IP is associated.

You can resolve this in one of two ways:

1. Install the pre-release 0.11.0.rc.0 version of `knife-ec2`.
   https://github.com/chef/knife-ec2/commit/e050c9c732798253baaf1008497ab6eb539f83c1
   commits a fix for the `ssh_connect_host` function, and the corresponding PR
   was merged after 0.10.0 released. You can do this by running `gem install
   knife-ec2 --pre`.
2. Apply the patch from
   https://gist.github.com/bojanrajkovic/fa4810162c3233cdeef6 in the `knife-ec2`
   gem's `lib/chef/knife` directory. It does some additional patching to have
   `knife` print the public IP that was assigned after the provisioning is done.

After you do that, the following `knife ec2` invocation should work:

```shell
knife ec2 server create \
    --node-name <YOUR NODE NAME> \ # e.g. Foo
    --ebs-size <EBS VOLUME SIZE IN GB> \ # e.g. 40
    --flavor <INSTANCE TYPE> \ # e.g. t2.medium
    --region <REGION> \ # e.g. us-east-1
    --subnet <VPC SUBNET> \ # e.g subnet-deadbeef
    --image <AMI ID> \ # e.g. ami-5b9e6b30, corresponding to the latest Server 2012 R2 RTM image in us-east-1
    --security-group-ids <SG LIST> \ # e.g. sg-deadbeef,sg-beefbeef -- the list must be comma-separated
    -A <AWS_ACCESS_KEY> \
    -K <AWS_SECRET_KEY> \
    --ssh-key <KEY NAME> \ # must correspond to a .pem file in ~/.ssh/
    --user-data <PATH TO USERDATA FILE FROM STEP 3> \
    --winrm-user Administrator \
    --winrm-password <PASSWORD FROM USERDATA FILE> \
    --winrm-transport plaintext \
    --associate-public-ip \ # Without a public IP, bootstrap can't download the Chef client
```

[0]: http://blog.coderinserepeat.com/2015/07/15/chef-knife-ec2-and-knife-windows/
[1]: http://blog.coderinserepeat.com/2015/07/16/chef-knife-aws-and-windows-part-3/
