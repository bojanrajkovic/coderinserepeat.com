---
title: "Bringing Rust to C#: Oxide and Oxide.Http"
tags:
- Rust
- Functional Programming
- C#
- Oxide
category: Software Engineering
---

Rust is a language I've admired for a long time now, from a slight distance.
I've read about the borrow checker, perused the standard crates, and read up on
Cargo and the way that Rust applications and libraries are built, tested, and
shipped. I appreciate its striving to be a systems-level language that also
cares about safety and developer productivity.

I haven't _written_ as much Rust as I'd like to (though I did start a few small
projects here and there), but that didn't stop me from thinking that maybe some
of its standard library features have a place in the C# world. I found myself
particularly fond of the [Option][rustopt] and [Result][rustresult] types, and
their ability to better the flow of my code. Option's API is `Nullable<T>` on
steroids, and Result provides an elegant way to express an error that doesn't
require using out parameters or custom exceptions, while at the same time
providing a delightful API that lets you build processing pipelines that
preserve errors and lazily evaluate steps.

The adventure started when one afternoon about a month ago, when I decided I
wanted to see if I could implement `Option` in C#. I knew I wanted to preserve
as much of the Rust API as made sense, including the simple construction of
`Some` and `None` as function calls: `Some(5)`, `None<int>()`, etc. I opened
up [Workbooks][workbooks] (use what you know, right?) and started hacking away.
After a little while, I had my first pass at the `Option` API surface&mdash;I
stuffed it in a [Gist][gist], Within a few hours, I decided to make it into a
library called [Oxide][github]&mdash;after all, what else is Rust?

My [initial commit][first] brought in the API almost exactly as it was in the
Gist. Over the rest of the day, I refined the API slightly, added a ton of tests
(inspired by the Rust documentation's example assertions), and wrapped up. A
week later, I decided to add `Result`, which I implemented largely the same way
(a base class, with derived `Ok<T, E>` and `Err<T, E>` classes).

Since then I've refined the API for both, added a priority queue implementation,
added a small library of HTTP helper methods (Oxide.Http), received my first
external contribution from [Jérémie Laval][jeremie] who contributed a very nice
set of convenience methods to enable async/await with Option, and finally
published a NuGet (when I was forced to by wanting to use Oxide in another
project but wanted to avoid submodules).

I hope to keep working on Oxide&mdash;there will probably be more APIs that I
would like to borrow from Rust, or more functional/Rust-inspired API that would
be useful for C# developers. Contributions of all kinds are welcome: bug
reports, feature requests, documentation, etc. You can find
Oxide [on GitHub][github]&mdash;please use the issue tracker there for
everything. :)

[rustopt]: https://doc.rust-elang.org/std/option/enum.Option.html
[rustresult]: https://doc.rust-lang.org/std/result/enum.Result.html
[workbooks]: https://developer.xamarin.com/guides/cross-platform/workbooks
[gist]: https://gist.github.com/bojanrajkovic/b1ff4d52fccffcf7e6e98aa041b52ee7
[first]: https://gist.github.com/bojanrajkovic/b1ff4d52fccffcf7e6e98aa041b52ee7
[jeremie]: https://twitter.com/jeremie_laval
[github]: https://github.com/bojanrajkovic/Oxide
