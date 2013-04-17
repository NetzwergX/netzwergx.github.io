---
title: Installing (and/or migrating) TS3 on Debian 6
layout: article
excerpt: This guide covers how to install a teamspeak3 server on Debian 6, as well as migrating from an old installation.
categories: Linux
tags: [server, linux, debian, teamspeak]
---

Basic Setup
-----------

At first I recommend setting up a new user, under which the ts3 server will run. I do not recommend 
running the server as `root`.


In this guide the user, under which the ts3 server will run, is named `ts3user` and will have its home 
directory located at `/home/ts3user/`. So we first create the home directory:


	mkdir /home/ts3user

Then we create the user:

	useradd -g users ts3user -d /home/ts3user/ -s /bin/sh

After that we set his password (you will get a prompt to type in the password):

	passwd ts3user

And at last we appoint him as the owner of the newly created directory:

	chown ts3user /home/ts3user/

Finally, we switch to that directory:

	cd /home/ts3user

Getting the software
--------------------

Check out http://www.teamspeak.com/?page=downloads to find the proper download URL. As of this 
writing (21/02/2013), the current server version is 3.0.6.1 and for this example I am using the 
64-Bit version for linux. You can easily retrieve it using `wget`:

	wget http://teamspeak.gameserver.gamed.de/ts3/releases/3.0.6.1/teamspeak3-server_linux-amd64-3.0.6.1.tar.gz

And after that, unpack it: 

	tar xfvz teamspeak3-server_linux-amd64-3.0.6.1.tar.gz
	
Following this, the next steps differ regarding migrating from an old server or for a fresh installation.


Installation
------------

First of all, make sure you are running the server as the ts3 user:

	su ts3user
	
Fortunately, the installation itself is very easy. Just run 

	./ts3server_minimal_runscript.sh
	
and you will get an output that looks like this:


	I M P O R T A N T
	------------------------------------------------------------------
	Server Query Admin Account created
	loginname= "serveradmin", password= "*********"
	------------------------------------------------------------------
	ServerAdmin token created, please use the line below
	token=****************************************

	
You will need those values to gain administrative rights on your server. I recommend saving them temporarily 
in a text file. Currently, the ts3 server runs in your active shell, which is only active as long 
as you keep the ssh session active.

To get the server running as a daemon, you can use the `ts3server_startscript`:

	./ts3server_startscript.sh start
	
Valid parameters for the start script are `start`, `stop`, and `restart`, which should be self-
explanatory.

After connecting to your ts3 server via the ts3 client, go to `Permissions` -> `Use privilege key` 
and insert the ServerAdmin token from above. Now you have administrative rights on your server and are done 
with setting it up.


Migrating
---------

This section only covers migrating a server using sqlite, since that is the only scenario I am 
familiar with.


If you already have an active ts3 server somewhere else, you just need to copy over the `files/` 
directory inside the ts3 directory and the `ts3server.sqlitedb` file as well as your license file 
(should you use one). Then you can tjust run the server using the start script and it will work just
as your old one.

This works regardless of your old ts3 version. I had an older version, which was 32-bit and have now 
the current version in 64-bit - no further work was needed.


This concludes this quick guide, I hope it was helpful. You can [leave comments by filing an issue
on GitHub](https://github.com/NetzwergX/netzwergx.github.com/issues).
