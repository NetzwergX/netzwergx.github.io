---
title: Release of Jekyll Template Toolkit (JTT)
tags: [jekyll, git, github, github-pages, jtt]
categories: [jekyll]
---
Today I've released my Jekyll Template toolkit, a collection of templates and layouts for jekyll, 
which is 100% compatible to github-pages. The source code can be found in the 
[repository on GitHub](http://github.com/NetzwergX/jekyll-template-toolkit.git).

JTT was designed with the aim to provide an easy entry to blogging with jekyll on github-pages. It
provides a collection of widgets that can be used everywhere on a page as well as some pre-defined
layouts for whole pages, including a category page, tags page, archive page and a RSS feed.
The whole set of provided templates is described below.

Widgets
-------

* **Category List** (categoryList.html)

	A simple list containing all categories and the number of posts within.
	Useful for navigations, e.g. in sidebars.

* **Post Timeline** (timeLine.html)

	A time line containing all month in which posts were published, grouped by year.
	Useful for navigations, e.g. in sidebars.

* **Tag Cloud** (tagCloud.html)

	A linear-weighted tag cloud. 
	
* **Similar posts list** (similarPostList.html)

	A list containing similar posts.
	Useful to provide some "Further reading" links to the user. It only works on post pages.
	
* **Google Search box** (googleSearchForm.html)

	A very simple search box with an input field and submit button. It searches via Google.

* **Tapir search box** (WIP)

	A search box for searching the site via Tapir (<http://tapirgo.com/>).	
	
		
Pages
-----

* **Category Page** (categories.html)

	A page listing all posts grouped by category.
	Has IDs in order to jump directly to a specific category.

* **Archive Page** (archive.html)

	A page listing all posts grouped by year and month.
	Has IDs in order to jump directly to a specific month or month-year combination.

* **Full Feed Page** (fullFeed.xml)

	Provides a RSS 2.0 Feed containing all posts.	
	
* **Feed Page** (fullFeed.xml)

	Provides a RSS 2.0 Feed containing the X latest posts. Defaults to 5.	
		
		
Layouts
-------

* **Page** (page.html)

	Boilerplate base layout for all layouts.
	
* **Index** (index.html)

	Index page rendering post list with pagination.
	
* **Article** (article.html)

	Post page showing one post.
	
* **Feed** (feed.xml)

	Base layout for RSS 2.0 feeds.
	
	
Further information:
-----------------
		
You can find further information in the 
[README.md](https://github.com/NetzwergX/jekyll-template-toolkit/blob/master/README.md) and wiki of 
[the repository on GitHub](http://github.com/NetzwergX/jekyll-template-toolkit.git).
