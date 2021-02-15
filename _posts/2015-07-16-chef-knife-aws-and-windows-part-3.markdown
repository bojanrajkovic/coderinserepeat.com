---
title: 'Chef, Knife, AWS, and Windows: Part 3'
date: '2015-07-16 21:17:57'
tags:
- Windows
- Chef
- Configuration Management
- EC2
- Knife
- AWS
---

In Parts [1][0] and [2][1], I got started with Chef, `knife-ec2` and
`knife-windows` to bootstrap Windows machines. I've been slowly chipping away at
the required amount of "configuration" as I discover more `knife` features. This
time, I've found that you don't have to set a password on the node—`knife` can
retrieve it from EC2 via the API, as long as you tell it where to look for your
identity file.

Step 1: Tell `knife` where our identity file is. For Windows machines, there's
no SSH, but the identity file is used anyway to encrypt the administrator
password. This bit of configuration goes in our `knife.rb`:

```ruby
knife[:identity_file] = "/path/to/foo.pem"
```

Step 2: Remove the password setting from our Powershell script&mdash;we don't
need an explicit password anymore. That means removing these two lines:

```powershell
$admin = [adsi]("WinNT://./Administrator, user")
$admin.psbase.invoke("SetPassword", "Ch4ng3m3")
```

Step 3: Remove the explicit username/password settings from our `knife` command.
Remove these two lines from the `knife` invocation given at the end of part 2:

```shell
    --winrm-user Administrator \
    --winrm-password <PASSWORD FROM USERDATA FILE>
```

Rerunning the full command now should provision a Windows machine, just like
before, except with a bit of time savings of not having to generate a new
password for every machine. :)

[0]: http://blog.coderinserepeat.com/2015/07/15/chef-knife-ec2-and-knife-windows/
[1]: http://blog.coderinserepeat.com/2015/07/15/chef-knife-and-windows-part-2/
