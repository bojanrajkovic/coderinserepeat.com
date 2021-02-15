---
title: Windows, SSH Agent, and Emacs
date: '2015-06-25 13:33:43'
tags:
- Powershell
- Git
- Emacs
category: Goldplating the Boiler Room
---

Because I'm a sick sort of puppy, I work in Emacs on Windows for basic text
editing and especially for working with Git ([Magit][0] is the best), and use
Powershell (and Posh-git) for my shell. However, if I launch Emacs from a pinned
shortcut on my taskbar instead of from within a Powershell session, I don't get
access to `ssh-agent`, which puts a bit of a damper on actually working with
Git.

As it turns out, the Magit team has already mostly solved this problem -- they
modified [GitHub's ssh-agent start script][1] to emit a small piece of Emacs
Lisp that sets the `SSH_AUTH_SOCK` and `SSH_AGENT_PID` environment variables
using the `setenv` function. Here's that code ported to Powershell:

```powershell
# Write the SSH agent environment variables so that emacs can pick them up
$agentVarsFile = "$env:USERPROFILE\Dropbox\.emacs.d\ssh-agent-vars.el"
# Truncate the file first
Set-Content $agentVarsFile $null
# Now add to it
Add-Content $agentVarsFile ("(setenv `"SSH_AGENT_PID`" `"{0}`")" -f $env:SSH_AGENT_PID)
Add-Content $agentVarsFile ("(setenv `"SSH_AUTH_SOCK`" `"{0}`")" -f $env:SSH_AUTH_SOCK)
```

You should change the path to suit your needs -- I keep my `.emacs.d` folder in
Dropbox and symlink it into place, so I chose the direct path approach. This
code sits in my Powershell profile directly after the Posh-git bits are loaded
and ssh-agent is started (or is already running). Then, all that's necessary is
to add a bit of code to my Emacs `init.el`:

```elisp
(load-file "~/.emacs.d/ssh-agent-vars.el")
```

Now, Emacs will load that file when it starts -- as long as ssh-agent is running
before Emacs is started, it'll work fine. If it's not, I can always re-evaluate
that bit of Elisp and get the environment loaded after the fact.

[0]: https://github.com/magit/magit
[1]: https://help.github.com/articles/working-with-ssh-key-passphrases/#platform-windows
