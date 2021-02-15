---
title: Combining EF6 with ASP.NET 5
date: '2015-01-20 04:31:56'
tags:
- Entity Framework
- ASP.NET 5
- ASP.NET vNext
category: Software Engineering
---

For some upcoming work my team is doing, we wanted to use Entity Framework as
our base DAL (with a micro-mapper like [Dapper][] overlaid on top) and ASP.NET 5
as our web stack. However, Entity Framework 7 (in development alongside ASP.NET)
won't be ready for prime-time according to [this blog post][] by Rowan Miller of
the EF team. In particular, lazy loading and inheritance mapping are going to be
missing. We were able to make Entity Framework 6 and the associated tools work
with some clever use of new features in ASP.NET.

My first attempt was to naively add the package reference to the `project.json`
file, which did not work. I later learned from [@davidfowl][] that the
Powershell scripts aren't run for packages in ASP.NET 5 projects because they're
not cross-platform. Since we wanted to use the code-first approach, this was not
viable.

My next attempt was to run the Powershell scripts manually (they were unpacked
into the package cache directory) and get them loaded into the right context so
that we could use them inside Visual Studio. This didn't work, as the scripts
needed variables from Visual Studio that I couldn't reproduce.

The next attempt was to create a new "classic" class library project and add EF6
to that. The Powershell tools work from here, but we have one small problem: we
can't reference this project from the ASP.NET 5 project&mdash;it doesn't get
resolved as a reference. The final solution combined this with a clever hack
enabled by the `project.json` file's flexibility:

1. Use the classic class library we just created.
2. Add the EF6 reference and any other necessary references to the ASP.NET 5
   Class Library project. Keep this reference list in sync.
3. Adjust the project.json file's `code` section for the ASP.NET 5 class library
   to transclude the EF6 project's code files: `"code": [ "**/*.cs",
   "../EF6Project/**/*.cs" ]`.
4. Reference this project from the web app project.
5. Profit!

What's happening here is that we're using the `project.json` file's flexibility
to transclude the source files from the "wrapper" project for EF6 into the
ASP.NET 5 class library, and keeping the references in sync means the compiler
works just fine all the way up the chain.

This lets us use EF6's features that aren't yet in EF7, and use the EF6 tools at
the same time. Unfortunately, it doesn't do anything for us to make it easier to
port to EF7 down the road, as they're not likely to be source-compatible, but
that's a bridge to cross later on.

[this blog post]: http://blogs.msdn.com/b/adonet/archive/2014/12/02/ef7-priorities-focus-and-initial-release.aspx
[@davidfowl]: https://twitter.com/davidfowl
[ASP.NET]: https://asp.net/vnext
[Dapper]: https://github.com/StackExchange/dapper-dot-net
