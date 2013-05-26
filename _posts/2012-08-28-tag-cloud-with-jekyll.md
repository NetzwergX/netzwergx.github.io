---
layout: article
title: Tag cloud in jekyll (without plugins)
tags: [jekyll, github, github-pages, jtt]
categories: [Jekyll]
---
Creating a tag cloud with jekyll is not a simple task and most solutions found online use plugins for that. 
In this article I describe the solution I've found, which is baesd on a vanilla jekyll installation without plugins.
My solution is based around the fact that there are several math filters available for Liquid:
	<pre>
		{% raw %}{{5 | plus: 3}}{% endraw %} => 8
		{% raw %}{{5 | minus: 3}}{% endraw %} => 2
		{% raw %}{{5 | times: 3}}{% endraw %} => 15
		{% raw %}{{6 | divided_by: 3}}{% endraw %} => 2</pre>	
More filters and documentations can be found on the [Shopify/Liquid Page](http://wiki.shopify.com/FilterReference#Math_Filters).
 		
Although these filters are present, using them is not easy, as you can not set brackets in terms,
and jekyll processes arguments for filters quite oddly from time to time.

Basically, these math filters allow for calculating a **wheight** for a given tag. Due to the nature of
the maths filters, I chose quite a simple linear approach. Bigger blogs with a multitude of tagged 
posts might add a threshold for displaying tags and use another scaling, but that will be more
difficult.

Constructing the tag cloud
--------------------------
The number of tags can be easily retrieved by `{% raw %}{{ site.tags.size }}{% endraw %}`.

Looping through the tags is equally simple:
<pre>
	{% raw %}{% for tag in site.tags %} 
	... 
	{% endfor %}{% endraw %}
</pre>

Inside the loop the name of the current tag can be retrieved via `{% raw %}{{ tag | first }}{% endraw %}`.

The posts with that tag are the second / last element of `tag`, so we can retrieve the # of posts
tagged with it via `{% raw %}{{tag | last | size}}{% endraw %}`.

### Some math

So the next thing to figure out was a proper math formula that could be implemented with the limited
capabilities of liquid math filters.

A quite simple approach is to measure the percentage of posts with the given tag:
<pre>(# posts with tag 'X') / (# of posts) * 100</pre>
which could be written as:
<pre>(# posts with tag 'X') * 100 / (# of posts)</pre>

Additionally, I decided to add an offset of 100%, ensuring that each tag will have a minimum size that
is readable. Of course I lowered the font size for the tag cloud via CSS beforehand.

### Implementing it in jekyll
Possessing a simple formula, implementing it in jekyll was quite trivial:
<pre>{% raw %}{{tag | last | size | times:100 | divided_by:site.tags.size | plus:100}}
{% endraw %}</pre>
It can be used in inline-CSS to set the `font-size` property of the tag.

Result:
-------

You can see the tag cloud working on this blog in the sidebar on the right hand side. I've also released the tag
cloud in my [Jekyll Template Toolkit](http://github.com/NetzwergX/jekyll-template-toolkit.git), which
I [released recently](2012-08-27-release-jekyll-template-toolkit.html).

The complete source code of the tag cloud can be found in 
[\_includes/widgets/tagCloud.html](https://github.com/NetzwergX/jekyll-template-toolkit/blob/master/_includes/widgets/tagCloud.html).
