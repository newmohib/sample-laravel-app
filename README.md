# Installing Laravel on Linux
Note:  This document is not finished.

##### Written for Laravel 2.3 and PHP 7
This is written for Ubuntu, LinuxMint, and oter debian derivatives that use apt or apt-get.  I have tested it on Ubuntu 16.04 LTS.  Also, this installation may not be the minimum.  In particular, some of the php files May not be absolutely necessary, especially if you are not running nginx and valet.

I have this guide on Fedora using "dnf" instead of apt should work in most places.  A few of the PHP bundles are a bit differentently, but It still worked.  The Fedora packages seem to be more inclusive, so all of the important PHP components seemed to be loaded.

## Homestead
Homestead is a useful tool.  but it can be overwhelming at first if you are trying to learn both Laravel and Homestead.  
It is much easier and quicker to whip up little learning projects without Homestead.  In my experience Homestead makes
things easier for people using Windows.  

I do recommend Homestead if you are working on dedicated projects.  

** Valet
I like Valet.  However, it is one more thing that needs to be installed (two, if you count nginx).  My advice to students is
to try to install valet.  If that doesn't work at first, then just use the built-in php server.  Worry about fixing the
problem once you are comfortable with the environment.

##The general procedure is 

1. Install PHP extensions
2. Fix PHP configurations
3. Install Composer
4. Install Laravel
5. Test Laravel and Artisan
6. Optionally:
   * Install NGINX server
   * Install Valet
   
## Steps
Both of the following are kind of old.  But they are still useful references:
* [https://www.digitalocean.com/community/tutorials/how-to-install-laravel-with-an-nginx-web-server-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-install-laravel-with-an-nginx-web-server-on-ubuntu-14-04)
* [http://tecadmin.net/install-laravel-framework-on-ubuntu/](http://tecadmin.net/install-laravel-framework-on-ubuntu/)

In the following instructions I install packages one at a time.  Some probably find this inefficient.  However, I assume people may have problems across time and distributions.  In these types of situations I prefer to install one at a time so it is easier to identify exactly which packages fail.

### Step 1 install php
Open a command window.  Type the following commands.  This command also installs the GIT protocol.  Git isn't technically necessary, but you should still install it so it is available.  

These installs should be straightforward.  They should work regardless of what system you are using.

    sudo apt update
    sudo apt install php 
    sudo apt install git
    sudo apt install curl
    
This step could have been done as part of the above.  However, these installs may be more problematic over time.   If these commands don't work for you, it may be necessary to research your specific system.

    sudo apt install php-common
    sudo apt install php-curl
    sudo apt install php-json
    sudo apt install php-readline
    sudo apt install php-fpm 
    sudo apt install php-cli 
    sudo apt install php-xml
    sudo apt install php-mcrypt 
    sudo apt install php-zip
    sudo apt install php-mbstring
    sudo apt install php-gd
If you want to do it all in one shot, copy and paste the following
    
    sudo apt install php-common php-curl php-json php-readline php-fpm php-cli php-xml php-mcrypt php-zip php-mbstring php-gd

You can run the following command to clean up any unneeded packages.

    sudo apt autoremove

### Step 2 Change PHP configuration

Laravel needs mcrypt enabled.

    sudo phpenmod mcrypt
   
You may need to enable more, depending largely if you install nginx.

### Step 3 Install Composer

Composer may be installed globally or just for this user.  I assume you are going to be running it on your own development machine.  It will avoid some hastles if we just install it locally.

First, change back to your home directory.

    cd ~
    
Now fetch the composer installer and run it by pyping it through php.

    curl -sS https://getcomposer.org/installer | php

After this runs you should have a program in your home directory.  It should be named "composer.phar."  It is basically the working part of the composer program.   you should be able to execute it and get a help screen by typing the following:

    ./composer.phar
    
 To make composer more widely available, make it available outside your home directory.
     
     mv composer.phar composer
     chmod a+x composer
     sudo mv composer /usr/local/bin/composer
 Now you should just be able to type "composer" and get the same help screen you saw when you typed ./composer.phar   

This is a semi-tricky step.  You will need to edit a text file called .bashrc  (The leading dash is important).  You may use whatever text editor you wish.  The following command uses the "nano" editor.  We will be adding the folder ~/.composer/vendor/bin to the search path.

    nano ~/.bashrc

Go down to the bottom of the file.  There might or migh not we a command that starts export PATH.  If you find one, add the following statement after the other PATH statements  Note that there is a period in front of composer.

    export PATH=~/.composer/vendor/bin:$PATH

Save the file.   Close your terminal window.  You can just type "exit" in most cases.    Then open it again.  

The .bashrc file executes every time you open a terminal window.  By closing it and opening the window we executed .bashrc and added the new directory to the path.  (If you want to cheat, just type "bash" instead of opening and closing.  Now you will need to exit twice to close the terminal.  You are also using more system resources.)

You can check the path with the following command:

    echo $PATH
    
You should see that the path now ends with something like /home/yourID/.composer/vendor/bin

### Step 4 Install Laravel

Type the command.  Be sure to include the ~ before 1.1

      composer require "laravel/installer=~1.1"

### Step 5 Test Laravel and Artisan

Be patient.  Sometimes it takes a moment for the program to produce any output.  When it finishes running you should just be able to type "laravel" and see a help menu.

    laravel
    
#### :large_orange_diamond: Potential Problem :large_orange_diamond:
Some people have had problems with getting a "command not found" message on laravel.  This fix works, I suspect composer is installing a little differently than I think.  There may be a better organic fix, but the following does seem to work.

First, see if you have  .composer  or vendor directory by typing 
    
    ls .composer
    ls vendor
 If you are missing a .composer directory, but you have a vendor directory, then do the following two commands.

    mkdir .composer
    mv vendor .composer
    
The "laravel" command should now work.

#### Back to laravel:

### install xampp: https://www.apachefriends.org/download.html
	Download for ubuntu: xampp-linux-x64-8.0.28-0-installer.run
### need to be permission for this xampp:
	sudo chmod 755 xampp-linux-x64-8.0.28-0-installer.run
	sudo ./xampp-linux-x64-8.0.28-0-installer.run

### start/stop the services
	sudo /opt/lampp/lampp start
	sudo /opt/lampp/lampp stop
	sudo /opt/lampp/lampp restart
### open with control panel
	cd /opt/lampp
	ls
	sudo ./manager-linux-x64.run

### Go to xampp htdocs directory
	cd /opt/lampp/htdocs


### Need to be run this for Directory Permissions
sudo chown -R $USER:$USER /opt/lampp/htdocs

###Your First Laravel Project
	sudo composer create-project laravel/laravel example-app

## run the app
	cd example-app
	php artisan serve



## Step 6 Install nginx and valet
This step is optional.  In theory you should be able to view your web page with the built-in php server.

Some of these packages may already be installed.
    sudo apt install libnss3-tools 
    sudo apt install jq 
    sudo apt install xsel
    sudo apt install nginx
    
Use composer to install the ubuntu fork of valet.  I have also used it on Fedora and LinuxMint.

   composer require cpriego/valet-ubuntu
    
Move into the test folder we created earlier.  In my case this is 

    cd ~/act311/first
Type "ls" and make sure you are in the test database.  You should see folders including app and public.

Now we will wrap up and get vlalet linked to our project.  These commands may take a while to run.  I got some error messages, but things still worked for me.

    valet install
    valet park
    valet link
Now you should be able to open your browser.  Go to http://first.dev/  Your Laravel web page should show up.   With valet there is no need to run the php server from artisan.

### Remove all images
    docker rmi $(docker images -q) -f
    
### Docker Build Image
    docker build -t example-web .
### Docker Run Container
    docker run -p 3000:80 img-id
