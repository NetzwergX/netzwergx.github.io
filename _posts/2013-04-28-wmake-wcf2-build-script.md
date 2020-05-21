---
title: "wmake - WCF 2.0 package build script"
categories: [Woltlab]
tags: [WCF, package, WBB, shell, build, wmake]
---
The release of WBB4 and WCF 2.0 beta gets closer every day, and writing plugins for it becomes more and more interesting, especially since we knowget a good overview about the things that might not be included by default and make a good plugin. To make things easier, i wrote a little shell script that automagically packs WCF 2.0 packages: **wmake**!

Usage
---------

**wmake** is a package build script for WCF 2.0 packages. In order to work with **wmake**, you have to ensure that your packages structure adheres to the standards set forth by WoltLab.  
This means that your packages need to have the following file structure:

    + package.xml (required)
    + *.xml (XML-based PIPs, optional)
    + lang/ (Language Files, optional)
        +++ *.xml
    + *.php (Skript-PIP, optional)
    + *.sql (SQL-PIP, optional)
    + */ (File-based PIPs, e.g. Files-PIP, templates-PIP, ACPTemplates-PIP e.a.)

### Technical background
**wmake** will add all XML, SQL and PHP files and the root directory to your package, as well as all Language-Files placed in `lang/` (if applicable) and treat all other folders as File-based PIPs, meaning it will pack them as TAR and add them to the package archive as-is.

Download
--------------

**wmake** is a small shell script that is [available as Gist on GitHub](https://gist.github.com/NetzwergX/5476496).


