---
title: Building and Testing ASP.NET 5 Projects in TeamCity
date: '2015-01-25 21:54:54'
tags:
- TeamCity
- ASP.NET 5
- ASP.NET vNext
- Continuous Integration
category: Software Engineering
---

We've been using TeamCity for a long time due to its widespread use in the .NET
community&mdash;generally, if it can be done, someone's already done it and
blogged it. As part of new work we're doing, we wanted to get started building
and testing our work as early as possible. We ended up setting up the following
steps:

### Step 1

Install the `KoreBuild` package that the ASP.NET team has created to help in
bootstrapping projects. We set up TeamCity to execute the following Powershell
script:

```powershell
%teamcity.tool.NuGet.CommandLine.DEFAULT.nupkg%\tools\nuget.exe install KoreBuild -ExcludeVersion -o packages -nocache -pre -Source https://www.myget.org/F/aspnetvnext/api/v2
& packages\KoreBuild\build\kvm upgrade -runtime CLR -x86
& packages\KoreBuild\build\kvm install default -runtime CoreCLR -x86
& packages\KoreBuild\build\kvm use default -runtime CLR -x86
& %env.TEAMCITY_CAPTURE_ENV%
```

This gets the `KoreBuild` package installed in `.\packages\`, uses its base
tools to ensure sure the runtime and compilers are installed and ready, and most
importantly makes sure we capture the environment. `%env.TEAMCITY_CAPTURE_ENV%`
is an executable provided by TeamCity on each agent that makes sure the
environment is preserved between build steps (including `%PATH%`, custom
environment variables, etc.). I'm not sure where I found this info (probably
buried in the TeamCity documentation), but it was totally invaluable.

### Step 2

Restore NuGet packages! We restore in two phases, the first phase runs `kpm
restore` to restore the packages for ASP.NET 5 projects, and the second phase
restores the .sln file to pick up the old-style .csproj that contains our data
layer (see [my previous post on the subject][]) using TeamCity's `Nuget Install`
action.

### Step 3

To build the solution, we execute MSBuild directly on the .sln file. As TeamCity
has no support for VS2015/MSBuild 14 yet, we have to just run the executable at
`%env.ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe`. This does mean the
reported build output doesn't get interpreted by TeamCity, but I can live with
that for now.

### Step 4

Tests! We use xUnit (its development seems to be moving much faster than NUnit,
and it's known to work with ASP.NET 5, as it's what the team uses for their
development), and running tests is fairly simple -- the only trick is getting
output in such a way that TeamCity recognizes test runs and reports on them
correctly. The packages you need installed are `xunit` and
`xunit.runner.aspnet`, at versions `2.0.0-*` for both at press time
(respectively). The `test` command is defined simply as `"test":
"xunit.runner.aspnet"`, and the magic incantation for TeamCity's "Command Line"
build step is `k test -teamcity`, which
uses [TeamCity's built-in service reporting][] to provide test output. You'll
need to add the xUnit MyGet feed to your `NuGet.config` to get the packages,
it's at https://www.myget.org/F/xunit/.

All together, these scripts give us a robust build that ensures our tests get
run. We're still looking for a way to make coverage work (if anyone's managed to
make dotCover or NCover work with ASP.NET 5, give me a shout on Twitter), but
for now, something is better than nothing.

[my previous post on the subject]: http://blog.coderinserepeat.com/2015/01/20/combining-ef6-with-asp-net-5/
[TeamCity's built-in service reporting]: https://confluence.jetbrains.com/display/TCD8/Build+Script+Interaction+with+TeamCity#BuildScriptInteractionwithTeamCity-ReportingTests
