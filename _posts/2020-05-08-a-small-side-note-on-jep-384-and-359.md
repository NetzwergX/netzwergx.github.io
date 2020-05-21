---
layout: post
title: A small side note on JEPs 384 and 359
date: 2020-05-08 23:10 +0200
categories: [Java]
tags: [Records]
---

When reading about records and having read 
[Pattern Matching for Java, Gavin Bierman and Brian Goetz, September 2018](https://cr.openjdk.java.net/~briangoetz/amber/pattern-match.html), 
it would be easy to assume that pattern matching in `instanceof` would also include *deconstruction patterns*. 
This isn't a preview feature in Java 14 which included records via [JEP 359], but was slated for Java 15 with [JEP 384]. 
Unfortunately, this JEP has changed and deconstruction patterns are no longer planned for that JEP. 
Records will be re-previewed as-is.

[JEP 384]: https://openjdk.java.net/jeps/384
[JEP 359]: https://openjdk.java.net/jeps/359