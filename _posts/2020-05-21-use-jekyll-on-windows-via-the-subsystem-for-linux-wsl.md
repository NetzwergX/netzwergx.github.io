---
layout: post
title: Use Jekyll on Windows via the Subsystem for Linux (WSL)
date: 2020-05-21 21:36 +0200
categories: [Windows, Linux, Jekyll]
---

The Windows Subsystem for Linux works surprisingly well by now -- at least for simple tasks. In this blog post, I describe how to install the WSL as well as Jekyll (with GitHub Pages support) using Ubuntu as the distro of choice. Installing the WSL and a Linux distro is suprisingly easy and has only 4 steps (one is optional).

The official Jekyll Documentation a section on this ["Jekyll on Windows"](https://jekyllrb.com/docs/installation/windows/#installation-via-bash-on-windows-10), but unfortunately I found the information therein to be outdated.

1. **Activate Windows Subsystem**
In order to install the subsystem, you'll need to open a PowerShell window and type in the following:
`> Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
1. **Install a distro**
Visit the [Microsoft Store page for Linux Distros](https://aka.ms/wslstore) and choose a distro. For the sake of this blog post, I'll use Ubuntu.
1. Run `sudo apt update && sudo apt upgrade`
1. <span class="badge">Optional</span> Activate <kbd>Ctrl+<b>Shift</b>+V</kbd> & <kbd>Ctrl+<b>Shift</b>+C</kbd> via `RMB (Mouse) > Properties > Options (Tab) > Use Ctrl+Shift+C/V as Copy/Paste`
4. Run `$ lsb_release -a`, which should print:
```bash
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04 LTS
Release:        20.04
Codename:       focal
```


## Jekyll

If you have read the aforementioned documentation page of Jekyll, you'll have found this part:

> Now we can install Ruby. To do this we will use a repository from BrightBox, which hosts optimized versions of Ruby for Ubuntu.

Unfortunately, BrightBox does not support Ubuntu 20.04 LTS (Focal Fossa), which is what Windows installs when you use the MS Store:

    E: The repository 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu focal Release' does not have a Release file.
    N: Updating from such a repository can't be done securely, and is therefore disabled by default.
    N: See apt-secure(8) manpage for repository creation and user configuration details. 


Install `ruby-full` instead:

    $ sudo apt-get install ruby-full
    
And all build essentials, so that we can build gems with native extensions:

    $ sudo apt install build-essential patch ruby-dev zlib1g-dev liblzma-dev libsqlite3-dev nodejs

And finally, for the ease of handling gems, `ruby-bundler`.

    $ sudo apt install ruby-bundler

And.... that's it. You have now a fully everything needed to get going.

### Creating your first site

Lets get the first jekyll site going. The easiest way to set up Jekyll is using the GitHub-Pages gem. It is a great choice even if not deploying on GitHub Pages.

First, we create the following **Gemfile**:

    source 'https://rubygems.org'
    gem 'github-pages', group: :jekyll_plugins

And than its just a matter of installing the bundle and running Jekyll:

    $ bundle install
    $ bundle exec jekyll serve --watch

From time to time, you'll want to fetch new versions of the `github-pages` gem:

    $ bundle update github-pages