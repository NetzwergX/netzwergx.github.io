---
layout: article
title: Group posts by month and year in jekyll
tags: [jekyll, github, github-pages, jtt]
categories: [en]
lang: en
---
This article describes the technique used in this blog to display posts grouped by month and year in jekyll, most prominently seen in the widget within the sidebar. No plugin is required for this.

_If you are just interested in the synopsis and source code, jump to the bottom of the page_.

A common problem many people face when writing their page with jekyll is to display a timeline or 
archive widget, which shows posts grouped by month and year, quite common for most blogs.


The most widely used approach is to write a jekyll plugin for that, but as I wanted to build my 
page directly on GitHub, that was not an option. So I started building a solution in pure jekyll,
which is based around `{% raw %}{% assign key = value %}{% endraw %}`. 

Conception
----------
Since I am in the habit of giving things a thorough thought before starting, I took pen & paper and made a 
general concept of how this should work.

###HTML markup
First of all I have laid out the result I wanted to achieve in HTML. Since this is a grouped list, using 
nested lists was the semantic correct approach. This is pretty straight forward:

		<ul>
			<li>[Year X]
				<ul>
					<li>[Month A]
						<ul>
							<li>[Post I]</li>
							<li>[Post J]</li>
							.
							.
							.
						</ul>
					</li>
					<li>[Month A - 1]
						<ul>
							<li>[Post K]</li>
							.
							.
							.
						</ul>
					</li>
				</ul>
			</li>
			<li>[Year X - 1]
				<ul>
					<li>
					.
					.
					.
					</li>
				</ul>
			</li>
			.
			.
			.
		</ul>
		
It can easily be seen that the whole nesting might get a little bit complicated. As it turned out,
getting the nesting of the markup right was indeed the major problem I had to face, not grouping the posts.

### Grouping the posts
How do I group the posts now? Well, we can easily use the `|date:''` filter for that. Simply 
looping through the `site.posts` array and comparing the year of the current post with the year
of the next post will give us the possibility to group posts by years.

Equally, comparing the month of the current post with the month of the next post will allow us to 
group the posts by month.

Some special consideration have to be made for the first and the last post. When looking at the first
post, we will always have to generate the list for the year and the month of that post. Likewise
the month and year list have to be closed when looking at the last post.

The other two possible cases are: 

* Month changes
* Year changes

When only the month changes, the month list has to be closed, then re-opened and the month header 
has to be included.

When the year changes, both, the month list and the year list have to be closed and then re-opened 
with appropriate headers.

One trap I almost fell into was that while the year might change, the month might not. Consider
the situation when there has not been a blog post for a year, e.g. one post in May 2010 and one in May 2011.
While iterating through the posts array, the year will change, but the month will not. I know it's
an edge-case that might not apply to the real world, but I wanted to be thorough.


Implementation
--------------

The first task was to get the year and month of the current and next post - that was pretty
straightforward as we can use the `|date` filter:
{% raw %}
		{% if post.next %}		
			{% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
			{% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
			{% capture month %}{{ post.date | date: '%B' }}{% endcapture %}
			{% capture nmonth %}{{ post.next.date | date: '%B' }}{% endcapture %}
		{% endif %}
{% endraw %}

I also wrapped this in an if-statement to only read year and month when there is really something
to compare it with left; meaning, when it is not the last post. While I could have used `forloop.last`,
I felt using `post.next` is easier to understand. We can, however, utilize `forloop.first` to check
if we are looking at the first post or not.

So, having all this laid out and considered, the implementation is quite simple:
{% raw %}

		<ul class="postList archive">
		{% for post in site.posts %}
		
			{% if post.next %}		
					{% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
					{% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
					{% capture month %}{{ post.date | date: '%B' }}{% endcapture %}
					{% capture nmonth %}{{ post.next.date | date: '%B' }}{% endcapture %}
			{% endif %}
			
			{% if forloop.first %}				
					<!-- year -->
					<li><a href="/archives.html#{{ post.date | date: '%Y' }}">{{ post.date | date: '%Y' }}</a>				
						<ul>
							<!-- month -->
							<li><a href="/archives.html#{{ post.date | date: '%Y-%B' }}">{{ post.date | date: '%B' }}</a>							
								<ul>			
			{% else %}
				<!-- all other posts -->								
					{% if year != nyear %}	
								</ul>
							</li>						
							<!-- /month -->	
						</ul>
					</li>
					<!-- /year -->
					<!-- year -->
					<li><a href="/archives.html#{{ post.date | date: '%Y' }}">{{ post.date | date: '%Y' }}</a>				
						<ul>
							<!-- month -->
							<li><a href="/archives.html#{{ post.date | date: '%Y-%B' }}">{{ post.date | date: '%B' }}</a>							
								<ul>		
					{% elsif month != nmonth %}
								</ul>
							</li>						
							<!-- /month -->	
							<!-- month -->
							<li><a href="/archives.html#{{ post.date | date: '%Y-%B' }}">{{ post.date | date: '%B' }}</a>							
								<ul>												
					{% endif %}					
		   {% endif %}	
		   {% comment %}<li><a href="/{{ post.url }}">{{ post.title }}</a></li>	{% endcomment %}
		   
		   {% if forloop.last %}
		  						 </ul>
							</li>						
							<!-- /month -->	
						</ul>
					</li>
					<!-- /year -->		
		   {% endif %}
		{% endfor %}														
		</ul>	
		
{% endraw %}	


This produces the nifty 'Archive' widget you can see here in the sidebar. If you also want to 
display the posts, just un-comment the line where the post gets displayed.

This widget and the 'Archive' page are also included in my 
[Jekyll Template Toolkit(JTT)](https://github.com/NetzwergX/jekyll-template-toolkit). You can
always find the latest version there.

