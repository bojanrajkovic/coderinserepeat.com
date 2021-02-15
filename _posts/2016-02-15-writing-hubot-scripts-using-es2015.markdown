---
title: Writing Hubot scripts using ES6+
date: '2016-02-15 03:22:22'
tags:
- Hubot
- ES6
- ES2015
- Babel
- JavaScript
category: Software Engineering
---

Since I discovered it shortly after moving into the world of Hipchat (and later
Slack) from the world of IRC, [Hubot][hubot] has been one of my favorite tools
to make my life better. I've always enjoyed ChatOps, from the early days when we
simply called it "writing eggdrop scripts," and Hubot brought ChatOps into the
modern age with its infinite flexibility and common platform that everyone could
build on top of.

Hubot itself is written in CoffeeScript, and traditionally, most scripts have
also been written in CoffeeScript. Unfortunately, I don't like CoffeeScript
much&mdash;I've always found it to be an ill-fitting crutch for Ruby developers
who didn't want to learn JavaScript, lest they cut themselves on the sharp edges
of braces. Meanwhile, ES6 (ES2015, really, but I'm set in my ways...) has
brought some really nice things to JavaScript development. I'm not going to list
any here, but take a look at kangax's [ES6 compatibility table][kangax-compat]
for an exhaustive list of everything ES6 brings to the table.

I've been slowly converting the scripts we use internally at [Xamarin][xamarin]
to at least be written in JavaScript, if not ES6&mdash;there hasn't really been
any good guidance on how to plug ES6 scripts into Hubot until recently, and what
there was seemed like it was only half of the story. Today I sat down and
figured out what needed to be done to make ES6 scripts automatically work.

### Step 1: Install a few packages

Install [`babel-register`][register], [`babel-preset-es2015`][preset],
and [`babel-plugin-add-module-exports`][exports]. Visit the respective module
sites to learn more about them, but the short story is that the first two will
make sure Babel works, and the last package makes sure Babel exports
CommonJS-style defaults so that simple `require` calls will work.

### Step 2: Create a .babelrc

At the top-level of your Hubot repo, create a `.babelrc` file with the following contents:

```json
{
  "presets": [ "es2015" ],
  "plugins": [ "add-module-exports" ]
}
```

This will enable the ES6 preset and the `module.exports` plugin you installed
earlier.

### Step 3: Make sure Babel gets loaded early

Create a script that will be always be loaded first&mdash;I chose to name mine
`000-import-es6.js`. You can also make this a CoffeeScript script if you'd like,
but I stuck with plain old JavaScript. The contents should look like this:

```javascript
require("babel-register");
module.exports = function es6(robot) {};
```

The function export is not, in fact, required&mdash;it just makes Hubot shut up
about expecting a function but receiving an object when checking
`module.exports`.

### Step 4: Profit!

You can now write scripts using ES6&mdash;all of the features are available to
you to use. Put your scripts in the standard location for Hubot and they will
happily be loaded and compiled at runtime&mdash;you'll still get correct line
numbers in stack traces though, for which I am infinitely thankful.

### For Module Authors

If you're authoring a Hubot module _outside_ of your Hubot source tree, the
process is almost exactly the same&mdash;at step 3, instead of creating a
`000-import-es6.js` file, you can create an `index.js` in the root of your
package, with contents similar to this:

```javascript
require("babel-register");
var realDefault = require("./src/foo");
module.exports = realDefault;
```

A possible alternate solution is to require `babel-register`, then export a
function that uses Hubot's `robot.loadFile` method to load your actual script
entry point&mdash;I haven't tried this, so I don't know how well it would work,
but I suspect it would be just fine.

[hubot]: https://hubot.github.com
[kangax-compat]: https://kangax.github.io/compat-table/es6/
[xamarin]: https://xamarin.com
[register]: https://babeljs.io/docs/usage/require/
[preset]: https://babeljs.io/docs/plugins/preset-es2015/
[exports]: https://github.com/59naga/babel-plugin-add-module-exports
