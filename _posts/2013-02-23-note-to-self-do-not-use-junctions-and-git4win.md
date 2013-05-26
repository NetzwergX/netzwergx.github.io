---
title: "Note to myself: Do not use junctions with GitHub for Windows"
layout: article
categories: ["Notes to myself", Windows]
tags: [windows, github, bug]
---
The GitHub for Windows client does not work properly with junctions (`mklink /j ..`).  
I encountered this issue when I set up my working environment for WCF 2.0 on Windows (yes, I am back
to Windows temporarily for my working needs, but I will switch back to Linux *asap*).

The "GitHub for Windows" client stores your Git repositories under %Home%/GitHub/. This is fine
and it makes sense. However, is it not feasible when you want to develop PHP applications.

So I moved the files from the repository into a subfolder of the document root of my local web 
server and created a symbolic link (or, to be precise, a junction, since you can not create hard 
links on directories), back from that subfolder to the repository using `mklink`:

	mklink /J files/ "C:\xampp\some\path\to\app\"
	
At first glance this seemed to work just fine. In the Windows Explorer everything turned up 
right and editing the files worked as expected on all locations.

Then I opened up the GitHub for Windows client and navigated to my repo. And there they were, my
uncommited changes. I got a nice pretty diff showing my changes exactly the way I expected it. So
I typed in my commit message and commited them.

After that I almost toppeled from my chair. The newly created commit exhibited a "deleted" on all the files I 
had changed. And these were a lot of files - conincidentally all the files with changes - that
were shown as "New". Definitely not what I was expecting.

At first I thought the GitHub for Windows Client got confused by the creation of the junction while
it was monitoring the repository. So I closed the client and fired it up again; but nada, it happened
all the time, whenever I tried to change a file, the diff showed up correctly, but the commit itself
got screwed up.

I contacted the GitHub support about this and they confirmed that the issue with symbolic links 
under windows is already known and tracked in their internal issue tracker. They also mentioned that 
the shell shipped with GitHub for Windows is not affected by this malfunction and can be used. 
They assured me that they are trying to fix that issue in future releases.

tl;dr version: Do not use junctions with GitHub for Windows or if you do, stick to the shell.
