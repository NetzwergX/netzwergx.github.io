---
title: "Awesome etckeeper"
layout: article
excerpt: "The idea behind `etckeeper` is as simple as smart: Use a VCS to keep track of changes to config files in /etc/, providing you with a history, rollback options and much more."
categories: ["Linux"]
tags: [git, linux, etc, debian, ubuntu]
---
It is astonishing, how simple an idea can be, and how much trouble it can save. Keeping the whole /etc/ folder under version control is a simple, yet elegant solution to many problems with it. Mistyped something in the config? Screwed up something? Doesn't matter anymore. Check out your latest changes, and roll them back. Have forgotten why you changed _that_ setting to _this_, and why it was important? Check for the proper commit and read your own commit message explaining your change (if you were so careful to write one).

Really, `etckeeper` is worth gold. You do not need `etckeeper`to keep your `/etc/` under version control, but it certainly makes it easier, providing you with a common command line interface for multiple VCS. Currently, `etckeeper` supports [`hg` (Mercurial)](http://mercurial.selenic.com/), [`git`](http://git-scm.com/), [`bzr` (Bazaar)](http://bazaar.canonical.com/en/) and [`darcs`](http://darcs.net/).

`etckeeper` will automatically tracks changes made during package installation/removal, and snapshots the state of `/etc/` once a day.

Installation
------------
`etckeeper` will not ship a VCS with itself, you will have to install it yourself, before you can use it.

Here is an overview over the installation of various VCS using `apt-get`:

### Bazaar:

	sudo apt-get install bzr
	# installs bzr
	bzr whoami "Your name <your_email@example.com>"
	# sets your credentials

### Git

	sudo apt-get install git-core
	# installs the git client
	git config --global user.name "Your Name Here"
	# Sets the default name for git to use when you commit
	git config --global user.email "your_email@example.com"
	# Sets the default email for git to use when you commit

### Mercurial

	sudo apt-get install mercurial

After that, run 

	hg --version

If that gives you an old version, try adding `ppa:mercurial-ppa/releases` to your package sources and update.

You need to set proper credentials in `~/.hgrc`:

	[ui]
	username = Your Name Here <your_email@example.com>

### Getting `etckeeper`
Once you have set up your desired VCS, you can install `etckeeper` using `apt`:

	apt-get install etckeeper

At last, open `/etc/etckeeper/etckeeper.conf`, it should start as follows:

	# The VCS to use.
	#VCS="hg"
	#VCS="git"
	VCS="bzr"
	#VCS="darcs"

As you can see, by default bzr is used. comment this line with a `#` and uncomment one of the other lines to change the VCS used by `etckeeper`.

After that, commit your current state of `/etc/` with
	
	etckeeper commit "Initial commit"

And you are done.


Advanced usage
--------------

Since you are basically using a VCS (using git for example will initialize a `.git/` - repository in `/etc/`, you can use all features of your VCS also for tracking. This means that you can and should commit the changed files after each change, and should explain your changes in the commit message. This can save much, much time in the future when you are trying to re-think what you have done, and why.

You can also use other features of your VCS, such as branching. Want to try out a new configuration? Create a new branch (not using `etckeeper`, but using the VCS you are using with `ètckeeper`), make some changes, commit them and thoroughly test them, maybe even for some days. If it turns out those changes were good, merge said branch into the `master` branch and keep them. Otherwise, just switch back to the `master` branch and delete the old branch (or maybe merge only some commits from the branch into `master`). This is not really important on a desktop pc, but can be quite handy when used on a server. A good scenario is when you are tweaking performance issues, and set some variables for certain services to new values. You might want to monitor how that turns out for some days, and then decide wether to keep those changes, or not.


All in all, i have found [etckeeper](http://joeyh.name/code/etckeeper/) a very handy solution for keeping `/etc/` under control. It a simple, yet smart way of doing this.


This concludes this article, I hope it was helpful. You can [leave comments by filing an issue
on GitHub](https://github.com/NetzwergX/netzwergx.github.com/issues).

