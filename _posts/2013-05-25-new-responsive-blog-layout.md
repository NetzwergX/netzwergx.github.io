---
title: "New responsive blog layout"
layout: article
categories: [General, Jekyll]
tags: [jekyll, liquid, twitter, bootstrap, html5shiv, responsive, css, blog]
---
I wanted to make the blog layout responsive for a long time now, but since I don't even own a smartphone,
this wasn't really one of the top priorities for me. But then, the Jekyll 1.0 update came along, and I had
to rework the liquid templates anyway, since e.g. Jekyll now exports a `post.excerpt` variable on it's own.
So I sat down and started hacking, and I ended up reworking a whole lot of the templates to match
[Twitter-Bootstrap](http://twitter.github.io/bootstrap/), which I ended up using for the responsive grid
of the site.

Reworking the site also improved IE 6 &ndash; 8 compatibility. I now use html5shiv and some conditional
comments to adress various issues in old IE version, even IE mobile got some love.

Furthermore, the newsfeed is now an atom feed, which is much simpler to implement and maintain. Though
creating an RFC 3339 date in liquid wasn't as trivial as I thought (but more on that in another blog post).

Optical changes
---------------

First of all I think i managed to maintain the overall look of the site, but on the same time
giving it a fresh, and most importantly, more light-wheight look. The old design was good, but
it wasnt responsive and it was a little bit too much focused on the "paper" style boxes.

In the new design, only the most important site content is emphasized by that box, and all other
*meta* elements, e.g. the whole navigation in the sidebar, is much more inobstrusive. This puts
a heavy emphasize on the actual article itself. Take a look on the picture for comparison:

![Old blog layout](/assets/images/Home%20_%20Sebastian_Teumert_%20Blog.png "Old blog layout")
