---
title: Installing LAMP on Debian 6
layout: article
categories: [en, Linux]
tags: [server, linux, debian]
lang: en
---
Installing LAMP on debian 6 is refreshingly easy. This guide covers a typical LAMP (Linux, Apache, MySQL, PHP) installation on Debian 6. I had to set it up yesterday, so I thought I'd share some of the steps on the way. Since I have also needed a TeamSpeak3 server, there will be a follow-up on that, too. I will use example.org as a server domain, but replace it as appropriate for your needs when following the guide.

Basic Setup
----------------

At first, make sure your package lists are up-to-date:

	apt-get update

The first thing that is obviously needed is the webserver itself. Fortunately, Debian offers packages for almost all our needs.


	apt-get install apache2


And that's it for the webserver. If you now navigate to the IP-address of your server, you will see the default "It works!" message from Apache.

After that I decided to go for the MySQL server and also the client for maintenance etc.:

	apt-get install mysql-server mysql-client

You will be asked to enter the password for the root user. 

Now for PHP. I chose to install PHP5, the Apache PHP mod and the PHP-MySQL-Extension all at once:

	apt-get install php5 libapache2-mod-php5 php5-mysql

After that, you will probably want to customize your PHP installation a bit. I have considered these PHP extensions as useful:

	apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

Now, let's check out if everything is working. First of all we need to restart apache:

	/etc/init.d/apache2 restart

Then we create a file that outputs the `phpinfo();` into a web page:

	cat > /var/www/info.php
	<?php phpinfo(); ?>

To save this file , press `Ctrl+D`.

Now open `http://example.org/info.php` in your browser. It should display the PHP-Info page and show all the modules we have just installed.

And that's it. You have an operable webserver with PHP and MySQL.

Further notes
--------------


### phpMyAdmin

Operating the webserver without at least *some* tools will be a pain in the neck. A commonly used tool for database administration is [phpMyAdmin](http://www.phpmyadmin.net/home_page/index.php). Fortunately, there is also a debian package for phpMyAdmin available:


	apt-get install phpmyadmin 
	
You will get a dialog asking you for the usedweb server, something like this:                                                                      
                                                                                
	 ┌────────────────────────┤ Configuring phpmyadmin ├─────────────────────────┐  
	 │ Please choose the web server that should be automatically configured to   │  
	 │ run phpMyAdmin.                                                           │  
	 │                                                                           │  
	 │ Web server to reconfigure automatically:                                  │  
	 │                                                                           │  
	 │    [ ] apache2                                                            │  
	 │    [ ] lighttpd                                                           │  
	 │                                                                           │  
	 │                                                                           │  
	 │                                  <Ok>                                     │  
	 │                                                                           │  
	 └───────────────────────────────────────────────────────────────────────────┘   
                                                   
Make sure to hit `[] apache2`. After that you will be asked if you want to configure phpmyadmin via dbconfig-common. 

This will, however, not work out-of-the box. You will need to create a symlink that links the phpMyAdmin configuration to apache:

	ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin
	/etc/init.d/apache2 restart


If you now navigate to `http://example.org/phpmyadmin/` in your web browser, you should see the phpMyAdmin login page.

### Mod_rewrite

`Mod_rewrite` is disabled in the default apache2 configuration. You can easily enable it with `a2enmod rewrite`. `Mod_rewrite` is extremly useful for URL rewriting and widely used on web pages.

### Configuring virtual hosts

By default, apache servers all request from the default vHost that is hosted in `/var/www/`. If you want to serve multiple websites from your server, this configuration is unfavorable. 

The configuration for availabe sites is stored in `/etc/apache2/sites-available/`. The name of the default site is `default`. If you open it, it should look like this:

	<VirtualHost *:80>
		ServerAdmin webmaster@localhost

		DocumentRoot /var/www/
		
		<Directory />
			Options FollowSymLinks
			AllowOverride None		
		</Directory>
		<Directory /var/www/>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride None
			Order allow,deny
			allow from all		
		</Directory>

		ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
		<Directory "/usr/lib/cgi-bin">
			AllowOverride None
			Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
			Order allow,deny
			Allow from all
		</Directory>

		ErrorLog ${APACHE_LOG_DIR}/error.log

		# Possible values include: debug, info, notice, warn, error, crit,
		# alert, emerg.
		LogLevel warn

		CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>


I recommend moving the document root from `/var/www/` to `/var/www/vhost/default/` and changing the ServerAdmin to an appropriate value.

You can use the file above as a template for new web pages - create a new folder in `/var/www/vhosts/<new site>` and create a new config file in `/etc/apache2/sites-available/<new site>`, which you can enable by running
`a2ensite <new site>` and disable if not needed with `a2dissite <new site>`. Make sure to include `RewriteEngine On`, which is appropriate if you want to use `Mod_rewrite`.

You can find ample information on how to create virtual hosts [in the apache documentation](http://httpd.apache.org/docs/2.2/en/vhosts/).

This concludes this quick guide and I hope it was helpful for you. You can [leave comments by filing an issue on GitHub](https://github.com/NetzwergX/netzwergx.github.com/issues).
