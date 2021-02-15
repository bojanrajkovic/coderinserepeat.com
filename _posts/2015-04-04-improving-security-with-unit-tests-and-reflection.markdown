---
title: Improving security with unit tests and reflection
date: '2015-04-04 19:07:00'
tags:
- Testing
- ASP.NET 5
- ASP.NET vNext
- xUnit
- Security
category: Software Engineering
---

Back in November of 2014, [Phil Haack][0] published
his [_Avoid async void methods_][1] blog post—it contained two useful things: a
warning about an antipattern (I have to admit to not knowing about the
distinction between `async void` and `async Task` methods before), and a clever
application of unit tests and reflection to enforce best practices in a project.
As it turns out, that pattern can be repeatedly useful! Hooray for
metaprogramming!

[Cross-site Request Forgery][2] (hereon, CSRF) is a common attack vector for web
sites. Roughly speaking, CSRF attacks can execute requests on a vulnerable site
A when a user (who is authenticated at site A) visits malicious site B. The
OWASP link does a much better job explaining CSRF (with examples!), so I would
recommend reading it for a more detailed explanation. William Zeller and Edward
Felten's paper ["Cross-Site Request Forgeries: Exploitation and Prevention"][3]
is also worthwhile, though dense, reading.

Luckily for us, ASP.NET MVC (since MVC 3) comes with a built-in way to mitigate
CSRF attacks, using [`ValidateAntiForgeryTokenAttribute`][4]
and [`Html.AntiForgeryToken()`][5]. The implementation behind it is the
"double-submitted token" approach, in which an `HttpOnly` cookie is combined
with a value embedded inside the request (usually a form, but may be AJAX).
However, developers are prone to forgetfulness&mdash;it's especially easy to
forget to add `[ValidateAntiForgeryToken]` to action methods that take a POST.

After reading Phil's post and thinking about this some, I realized that I could
use the same approach (a unit test that reflects over types/methods) to enforce
this in our own code by making the test fail if it found a method that could
take a POST, but wasn't decorated with `[ValidateAntiForgeryToken]`. We're
working with ASP.NET 5/MVC 6, so the test code is xUnit, but it should be easily
adaptable to NUnit, MSTest, or any other testing framework.

Without any further ado, here's the test, with some type names changed to
protect the innocent:

```csharp
using Microsoft.AspNet.Mvc;
using System;
using System.Linq;
using Xunit;

[Fact]
public void All_post_actions_should_validate_antiforgery_token()
{
    var controllerTypes = typeof(MyController).Assembly.GetTypes()
                                              .Where(type => typeof(Controller).IsAssignableFrom(type))
                                              .ToList();
    var postActions = controllerTypes.SelectMany(type => type.GetMethods())
                                     .Where(m => Attribute.GetCustomAttribute(m, typeof(HttpPostAttribute)) != null)
                                     .ToList();
    var failingActions = postActions.Where(m => Attribute.GetCustomAttribute(m, typeof(ValidateAntiForgeryTokenAttribute)) == null)
                                    .ToList();
    var numFailing = failingActions.Count();

    var message = string.Empty;
    if (numFailing > 0) {
        var ending = numFailing > 1 ? "s:" : ":";
        var actions = string.Join(", ", failingActions.Select(a => $"{a.DeclaringType?.Name}!{a.Name}"));
        message = $"{numFailing} failing action{ending} {actions}";
    }

    Assert.False(numFailing > 0, message);
}
```

Hope this helps someone else out there! I'm hoping to be able to apply this pattern to other things as well.

[0]: http://haacked.com
[1]: http://haacked.com/archive/2014/11/11/async-void-methods/
[2]: https://www.owasp.org/index.php/Cross-Site_Request_Forgery_%28CSRF%29
[3]: http://www.cs.utexas.edu/~shmat/courses/cs378_spring09/zeller.pdf
[4]: https://msdn.microsoft.com/en-us/library/system.web.mvc.validateantiforgerytokenattribute%28v=vs.118%29.aspx
[5]: https://msdn.microsoft.com/en-us/library/system.web.mvc.htmlhelper.antiforgerytoken%28v=vs.118%29.aspx
