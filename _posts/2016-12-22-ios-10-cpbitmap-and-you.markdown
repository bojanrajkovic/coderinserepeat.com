---
title: iOS 10, CPBitmap, and you
tags:
- iOS
- CPBitmap
- Workbooks
category: Random Hacks
---

> Editor's note: this is an old post that I've published now. I've since
> found that CPBitmap files do contain a binary plist at the end, but it
> was not in the exact location described by most blog posts. I've got a
> bit of code written, but I'm not 100% happy with it yet, so it hasn't
> been published!

For a long while, I've been using a [photo of my cat Zooey][zooey] as my
iPhone's background image. Recently, I wanted to replace it with a different
one, but the picture of Zooey wasn't anywhere on my phone. iOS doesn't come with
a way to save the background picture, but I figured it couldn't be **that**
difficult. It had to be somewhere on the phone, or in a backup, in some
reasonable format&mdash;after all, my phone has to display it!

My first step was to start looking for where the file is on iOS&mdash;turns out
it's in `/var/mobile/Library/Springboard/LockBackground.cpbitmap` by default. If
your phone is jailbroken, there are tools you can use to access the file, but my
phone is not, so that was right out.

Luckily, with an unencrypted iTunes backup (iTunes backups preserve background
images!), and a handy tool called [iExplorer][iexplorer], I was able to find and
extract `LockBackground.cpbitmap`. With this in hand, I set out to find what the
format was, so that I could retrieve my image of Zooey.

The first thing I ran into was a reference to a converter service that someone
had published years ago at http://cpbitmap.cleverbyte.com.au/. This is no longer
up, but the same person had published the code to a [CodeProject article][cp]. I
downloaded the code, fired up Visual Studio, ran it, and attempted to run it on
my file. It crashed, and the file format didn't seem to match at all.

The next thing I found was many variations on a Python script that used
the [Python Image Library][pil] to extract the image, after skipping what the
script claimed to be a binary plist header. None of these worked
either&mdash;they almost all crashed after producing nonsensical image sizes
(they were reporting image sizes 40-60k pixels per side, iPhone 7 background
images are 750x1334).

After this, I started to look at the raw data itself, hoping to divine some
patterns. The first thing I saw was that the file was not any container format.
There was no magic number at the beginning&mdash;it was not a BMP, PNG, JPG,
TIFF, binary plist, or anything that I or `file(1)` recognized. I started
wondering if maybe this was not raw RGB data&mdash;in retrospect, I should have
thought of this earlier: iOS would prefer to blit this file to GPU memory as
fast as possible, and decoding a graphics format would just be a waste of time.

After some playing around with our [Workbooks][wb] product, I discovered that
what I had on my hands **was** RGB data&mdash;BGRA32 data, to be precise. Yet
when I created images from it, they were&hellip;wrong. You can see the broken
image [here][broken]&mdash;it's immediately obvious there's some sort of
"misread" in the pixels.

I'm not a seasoned graphics pro, so it wasn't immediately obvious to me, but
I [tweeted about it][tweet] and almost immediately got a message
from [Larry][lewing] that my issue was likely a row stride mismatch somewhere
(shortly followed by another Larry delivering the same message
via [tweet][lobrien]). After some discussion, Larry Ewing suggested that the
image might be 8-byte aligned w/ some 0-padding for easy blitting to GPU/SIMD. I
had been using a stride of 3000 (4*750)&mdash;I adjusted it to 3008 (the next
multiple of 8), and got the correct image!

A sharp observer might point out now that the image was already 8-byte aligned
before&mdash;after all, 750\*4 is 375*8. My guess is that they're padded not only
for alignment purposes, but also because iOS may not always be storing 750-pixel
wide images here. There may be a case where Apple is using the padding to both
indicate the end of a row and to pad it for easy manipulation, with no visible
changes (the extra 2 pixels won't show up on screen).

I'm hoping to throw together a little bit of publishable code to decode known
CPBitmap formats into something useful, so I would love to get my hands on more
samples of CPBitmap files&mdash;it would be interesting to see if/how the format
has changed with iOS version. If you happen to have an older iOS version
installed and can dump the files, please upload them somewhere and send me the
link!

[zooey]: https://coderinserepeat-my.sharepoint.com/personal/brajkovic_coderinserepeat_com/_layouts/15/guestaccess.aspx?guestaccesstoken=xCUeqwPCt%2fqm%2fBRMdOCqLI2O2KkeQIugtq713H7oth0%3d&docid=052323597d7204437a620ee5157f93392&rev=1
[iexplorer]: https://www.macroplant.com/iexplorer/
[cp]: http://www.codeproject.com/script/Articles/ArticleVersion.aspx?aid=265333&av=393837
[pil]: http://www.pythonware.com/products/pil/
[wb]: https://developer.xamarin.com/guides/cross-platform/workbooks/
[broken]: https://coderinserepeat-my.sharepoint.com/personal/brajkovic_coderinserepeat_com/_layouts/15/guestaccess.aspx?guestaccesstoken=NkoyPyzYJhBi4NB1NYa0MbM059rQtQbNcBKMUWk8uRk%3d&docid=0e64ced5c4ed1462ea5565ba78d88d17c&rev=1
[tweet]: https://twitter.com/bojanrajkovic/status/800420346180542466
[lewing]: https://twitter.com/lewing
[lobrien]: https://twitter.com/lobrien/status/800422504279871488
