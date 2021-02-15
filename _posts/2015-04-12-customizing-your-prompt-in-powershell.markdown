---
title: Customizing Your Prompt in Powershell
date: '2015-04-12 00:00:38'
tags:
- Powershell
- Windows
- Tweaks
- Terminal
category: Goldplating the Boiler Room
---

As I've been using Windows more and more (Visual Studio <3), I've grown to
really like Powershell. I was showing my brother around some of the more
powerful features of Powershell (for example, easy access to the entire WMI
namespace of machine information), and I realized "Why don't I make my prompt
show my battery information?" as an exercise in tweaking Powershell.

Turns out, it's pretty simple. To get battery information, you use the WMI APIs,
in particular the `Win32_Battery` object, which you can get by calling the
following:

```powershell
$battery = Get-WmiObject Win32_Battery
```

Once we've got the battery object, we can generate a short "status" string that
we can use for charging/AC but not charging/etc. states:

```powershell
switch ($battery.BatteryStatus) {
    { $_ -eq 2 } { $status = "AC" }
    { $_ -eq 3 -or $_ -eq 4 -or $_ -eq 5 } { $status = null }
    { $_ -eq 6 -or $_ -eq 7 -or $_ -eq 8 -or $_ -eq 9 } { $status = "Charging" }
}
```

The `BatteryStatus` values come from the [MSDN documentation][0] for
`Win32_Battery` (generally, MSDN documentation for WMI is fairly good).

From there, we can calculate a timespan for the remaining battery time, and
choose a color to represent our remaining charge:

```powershell
$time = [timespan]::FromMinutes($battery.EstimatedRunTime).ToString()
switch ($battery.EstimatedChargeRemaining) {
    { $_ -lt 25 }  { $color = 'red'; break }
    { $_ -lt 50 }  { $color = 'red'; break }
    default  { $color = 'white' }
}
```

We use the .NET `TimeSpan` object to convert minutes to a useful string, and a
simple switch against `EstimatedChargeRemaining` (an integer percentage of
battery left) to pick a color.

From there, we can concoct our final prompt string (or rather the battery status
portion of it):

```powershell
$realStatus = if ($status -ne $null) { $status } else { $time }
$batteryPercentage = $battery.EstimatedChargeRemaining
$text = "[battery: {0}%, {1}]" -f $batteryPercentage, $realStatus
```

And finally write it to the console by calling `Write-Host`:

```
Write-Host $text -foreground $color -nonewline
```

I use this in combination with [posh-git][1] to get repository status on my
prompt, so a typical prompt on my Windows laptop looks somewhat like this:

```powershell
C:\vcs\Mutiny [master] [battery: 95%, 08:27:00]> git status
```

In this case, Mutiny is my blog theme, and yes, that 8:27 figure is hours and minutes. Extended batteries are the best. :-)

[0]: https://msdn.microsoft.com/en-us/library/aa394074%28v=vs.85%29.aspx
[1]: https://github.com/dahlbyk/posh-git
