# .dotfiles

These are my configuration files and setup scripts for new computers. I use Windows 10 and Lubuntu/Ubuntu in most cases so these [dotfiles](https://dotfiles.github.io) will work on those systems. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

<!-- TOC -->

- [Setup Windows 10](#setup-windows-10)
  - [Run the `new-computer.ps1` script](#run-the-new-computerps1-script)
  - [Finish up](#finish-up)
- [(L)ubuntu](#lubuntu)
  - [Run the new computer script](#run-the-new-computer-script)
  - [After running the new computer setup script](#after-running-the-new-computer-setup-script)
- [All systems (finish setting up)](#all-systems-finish-setting-up)
  - [Git config](#git-config)
  - [Config Apache, PHP, MySQL](#config-apache-php-mysql)
    - [Apache](#apache)
    - [PHP](#php)
    - [MySQL](#mysql)

<!-- /TOC -->

## Setup Windows 10

1.  Install Windows
1.  Install addtional drivers (usually found on your backup drive)
1.  [Install Dropbox](https://www.dropbox.com/install) manually
1.  [Install Git](https://git-scm.com/download/win) manually
1.  Install Chocolatey
1.  [Install C++ 2015](https://www.microsoft.com/en-us/download/details.aspx?id=48145) manually (VS Code dependency)
1.  [Install VS Code](https://code.visualstudio.com) manually
    1.  [Install Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) for VS Code
    1.  Get Gist Token from secret hiding place
    1.  Type `sync` in the Command Palette in VS Code and copy/paste your GitHub token and Gist ID
    1.  Wait for all your extensions and themes to sync up and then close VS Code
1.  Using GitBash, clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the `new-computer.ps1` script

1.  Open PowerShell as admin and enable script execution: `Set-ExecutionPolicy RemoteSigned`
1.  Allow .NET packages to be installed via NuGet: `Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`
1.  Install Chocolatey: `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
1.  Close and re-open PowerShell as admin
1.  Then execute the `new-computer.ps1` script in order to install and configure all the things: `.\new-computer.ps1`

### Finish up

The following installations require special params during installation thus they are not included in `new-computer.ps1`

1.  [Install Ubuntu](https://www.microsoft.com/en-CA/store/p/ubuntu/9nblggh4msv6?rtc=1) from the Windows App Store
1.  Open Bash (in Windows 10) and symlink Ubuntu's `.bashrc` to the `.bashrc` in this repo. It'll be something like: `ln -s /mnt/c/Users/jonat/.dotfiles/bash/.bashrc /home/jonathan/.bashrc`
1.  Install Photoshop manually
1.  Install Lightroom manually
1.  Install Premier manually
1.  [Install MovesLink](http://www.movescount.com/connect/download?type=moveslink) manually
1.  Uninstall unwanted apps by right-clicking them in the Start Menu
1.  Setup SSH/Rsync on the Linux subsystem by copying your SSH config file to the home directory of your Linux subsytem. To find out that path, run `ubuntuhome` from the GitBash command line.

## (L)ubuntu

1.  Install Lubuntu
1.  [Install Dropbox](https://www.linuxbabe.com/cloud-storage/install-dropbox-ubuntu-16-04)
1.  Setup SSH keys
    1.  Copy (or [generate](https://help.github.com/articles/generating-ssh-keys/)) server keys from your secret hiding place to ~/.ssh (example: `cd secret/path && cp id_rsa ~/ssh/id_rsa`)
    1.  Ensure correct permissions on your .ssh directory and your keys: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa` For help with GitHub SSH keys see: [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/)
1.  Install Git: `sudo apt-get install git`
1.  [Install VS Code](https://code.visualstudio.com/docs/setup/linux)
1.  Clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the new computer script

```bash
# Make the new-computer.bash script executable.
cd ~/.dotfiles && chmod +x new-computer.bash

# Install and configure *a lot* of software.
./new-computer.bash
```

### After running the new computer setup script

1.  Set desktop preferences (panel postitions, etc.)
1.  Set folder and file browser preferences (folder size, etc.)
1.  Uninstall pre-packaged OS software that's not useful (such as games)
1.  [Install Hyper](https://github.com/zeit/hyper/releases)

## All systems (finish setting up)

### Git config

Run the `git-config.bash` script with Git Bash on Windows or Bash on Ubuntu: `chmod +x ~/.dotfiles/git/git-config.bash && ~/.dotfiles/git/git-config.bash`

### Config Apache, PHP, MySQL

#### Apache

Make these changes to `httpd.conf`:

1.  [`Listen 127.0.0.1:8080`](https://serverfault.com/a/276968/325456)
1.  `ServerName localhost:8080`
1.  Edit `DocumentRoot` section and the first `<Directory>` entry to point to your projects root folder
1.  Make sure this line is uncommented: `Include conf/extra/httpd-vhosts.conf`
1.  Ensure `DirectoryIndex` has `index.php` as a value
1.  [Setup localhost to use an SSL certificate](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-16-04)
1.  _Optional_: Ensure that `mod_rewrite` and `mod_expires` are enabled/uncommented in `httpd.conf`
1.  [_Windows_](https://brian.teeman.net/joomla/install-amp-on-windows-with-chocolatey): Copy/paste the following code block to the bottom of `httpd.conf` in order to ensure that Apache calls PHP when a request is made.

```apache
AddHandler application/x-httpd-php .php
AddType application/x-httpd-php .php .html
LoadModule php7_module "C:/tools/php72/php7apache2_4.dll"
PHPIniDir "C:/tools/php72"
```

##### And then...

1.  Add your virtual hosts to `httpd-vhosts.conf` (See `~/Dropbox/Sites` folder for a rough list)
1.  Edit your `hosts` file (_Windows_: `C:\Windows\System32\drivers\etc\hosts`; _Linux_: `/etc/hosts`) in order to point local dev sites to `127.0.0.1`

#### PHP

`php --ini` displays the current PHP configuration (`.ini`) file and `php -m` will show you all of the loaded modules.

#### MySQL

1.  [Set the root password for MySQL](https://brian.teeman.net/joomla/install-amp-on-windows-with-chocolatey)
    1.  Logon to MySQL: `mysql -u root`
    1.  Once logged in, set the root password: `ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';`
1.  Log into MySQL again (`mysql -u root -p`) in order to confirm that everything is running as expected (`show databases`).
