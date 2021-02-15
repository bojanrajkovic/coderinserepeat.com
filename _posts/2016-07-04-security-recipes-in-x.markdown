---
title: Security Recipes in X
date: '2016-07-04 20:11:52'
tags:
- Security
- C#
- Open Source
category: Security
---

A while ago, [Barry Dorans][blowdart] (who works on ASP.NET security at
Microsoft) tweeted that he was working with the Roslyn team to build security
analyzers. In particular, security analyzers based on commonly seen mistakes on
Stack Overflow, for example:

* ServerCertificateValidationCallback always returning true
* Cut-and-paste AES crypto with a deterministic IV

This
[got me thinking that what would be great is a collection of articles/code/blog posts][tweet] that
helps developers of all walks make good choices with regards to implementing
security primitives. Starting from the basics (teaching how to hash, etc.), to
symmetric cryptography, to asymmetric cryptography, TLS, etc. This could be a
resource that could be linked to from Stack Overflow, referenced on Twitter, or
used as a teaching tool.

To that end, I started exactly such a thing today! I'm structuring it roughly as
a book right now, with chapters covering broad concepts (for example, chapter 1
is "Hashing" right now), and sections within that chapter covering subtopics (so
far, I've only written one section, on using hashes to verify file content
integrity).

The idea is to write in a conversational, approachable style, and provide each
topic in digestible chunks, without going into excruciating detail about
implementations. Developers **do** need to know which algorithms are
recommended, but do **not** need to know about S-boxes, hash rounds, XOR shifts,
and other details of how the algorithms are implemented.

I would like to eventually provide implementations in multiple languages. I
started with C# because it's what I'm most natural with, but eventually it would
be great to have Ruby, Rust, C, Go, Javascript, and others represented.

I've created a [GitHub repository][repo] that has what I've done so far. The
code is licensed under the MIT license, and non-code pieces (ie. the prose that
constitutes each chapter) are CC-BY-NC-SA 4.0. Any contributions are
welcome&mdash;new languages, mistakes I've made (either in code or in prose),
etc.

I'm still refining how the prose and code are structured. I like what I've done
so far, with each section having code inline and a separate file containing all
the code without the prose for easy digestibility, but it may not make as much
sense to do that for languages that have better inline Markdown/code features
(Jupyter notebooks, etc.).

Comments? Suggestions? Complaints? Find me on Twitter, or open up a GitHub issue
on the repo!

[blowdart]: https://twitter.com/blowdart
[tweet]: https://twitter.com/bojanrajkovic/status/738147338657484800
[repo]: https://github.com/bojanrajkovic/security-recipes-in-x
