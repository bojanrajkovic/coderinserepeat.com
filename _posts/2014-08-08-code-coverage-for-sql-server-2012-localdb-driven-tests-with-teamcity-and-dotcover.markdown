---
title: Code Coverage for SQL Server 2012 LocalDB-driven Tests With TeamCity and dotCover
date: '2014-08-08 19:51:13'
tags:
- SQL Server
- TeamCity
- Testing
- Code Coverage
- dotCover
categories:
- Software Engineering
---

I started working on improving a codebase recently and one of the best ways to
do that is to start writing tests. The site is heavily database driven, so a
natural place to start adding tests was in the data layer (including ORM
mappings, abstractions, etc.) and in the service layer. The site is powered by
SQL Server, so I chose to use SQL Server 2012 LocalDB for testing to minimize
friction with the existing code. After writing a load of tests, I wanted to get
them running in TeamCity and get coverage numbers going. However, it was not as
easy as I expected.

Getting a build agent set up was easy enough, and it took about 30-ish minutes
total to start running tests. Introducing coverage didn't take much longer
(TeamCity helpfully includes dotCover for coverage), however, the first
coverage-enabled build runs didn't work. Every build raised the following error
from dotCover:

`[JetBrains dotCover] Coverage session finished with errors: Can't set event mask (COM error 0x80131377)`

My first Google searches led to JetBrains' bug tracker, where I found [this][1]
bug open about the same issue. I initially contacted one of the commenters, Will
Green ([@hotgazpacho][2] on Twitter), who told me that he had given up, as he'd
gotten the coverage reports working on his local machine, and didn't have time
to plug through getting it working on the CI server.

A little more Google searching (this time looking for the COM error code) led me
to Yi Zhang's blog on MSDN, where he had a [post][0] about HRESULT values
returned from .NET/the CLR. Looking up the code, I found that 0x80131377 meant
`CORPROF_E_INCONSISTENT_FLAGS_WITH_HOST_PROTECTION_SETTING`.

The long and the short of that value is that I was trying to run .NET code (ie.
the profiler) in the database, but host protection (also known as Code Access
Security, or CAS) was not having any of it. A quick MSDN search found that the
key was to either mark the assembly memebers as trustworthy (not an option, as I
don't own any of the involved assemblies), or to set the database as
trustworthy, which I could do.

As part of the test fixture setup, I drop and recreate the database, so as part
of that script, I added the following:

```sql
ALTER DATABASE UnitTests SET TRUSTWORTHY ON
```

~~I also ensured that the test runner was on the right bitness—TeamCity offers
auto, x86, and x64 values. I set mine to x64, as my build agent is a 64-bit
machine.~~ Once I finished this setup, I re-ran the build, and got coverage
resuts! After setting up my inclusions for assemblies to run coverage against, I
was all set to go.

I'm going to comment on the JetBrains' bug with the above suggestion for
resolving the issue for others, but I figured I needed to blog it first, so I
can give a little more detail than I can on a bug report.

**UPDATE**: The bitness setup isn't necessary—as Will reported in the comments,
he only had to run `ALTER DATABASE UnitTests SET TRUSTWORTHY ON` for success.

**UPDATE 2**: Comments are gone, but Will reported the following, which appears
to work reliably for me as well:

```
OK, I got it to work! The key is to start the SQLLocalDB instance (via the
SqlLocalDB utility) OUTSIDE the test framework context, then immediately run the
tests that connect to the database, then tear down the DB, again with the
SqlLocalDB utility.
```

[0]: http://blogs.msdn.com/b/yizhang/archive/2010/12/17/interpreting-hresults-returned-from-net-clr-0x8013xxxx.aspx
[1]: http://youtrack.jetbrains.com/issue/DCVR-4595
[2]: https://twitter.com/hotgazpacho
