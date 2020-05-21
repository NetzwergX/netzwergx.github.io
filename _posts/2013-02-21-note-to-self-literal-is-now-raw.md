---
title: "Note to self: `literal` is now `raw`"
layout: default
categories: [jekyll]
tags: [jekyll, blog, github-pages]
---
As of the last update to GitHub Pages, the `literal` tag is now `raw`.  
Today I wanted to start on a new series of blog entries, called "Notes to self". The "Notes to self" series of blog articles is a 
series of brief facts, tricks and code snippets that I consider to be useful, memorable and don't want to forget.

The first entry of this new series is about [GitHub Pages](http://pages.github.com). 


[Early this year, GitHub Pages was updated](https://github.com/blog/1366-github-pages-updated-to-jekyll-0-12-0) to Jekyll 0.12.0.
There are a few nifty new things, but there is also something not included in the changelog and not obvious to see:
The `{% raw %}{% literal %} {% endraw %}` tag is now `{% raw %} {% raw %} {% endraw %}`. So, if you happened to have blog posts
that included the `literal` - tag (like some of my previous posts), you have to update them to the new `raw` tag in order to
build correctly.
