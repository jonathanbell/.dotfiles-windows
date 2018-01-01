# .dotfiles

These are my configuration files and setup scripts for new computers. I use Windows 10 and Lubuntu/Ubuntu in most cases so these [dotfiles](https://dotfiles.github.io) will work on those systems. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

## Setup Windows 10

1. Install Windows
1. Install addtional drivers (usually found on your backup drive)
1. [Install VeraCrypt](https://www.howtogeek.com/howto/6169/use-truecrypt-to-secure-your-data/) manually
1. [Install Dropbox](https://www.dropbox.com/install) manually
1. [Install Git](https://git-scm.com/download/win) manually
1. [Install C++ 2015](https://www.microsoft.com/en-us/download/details.aspx?id=48145) manually
1. [Install VS Code](https://code.visualstudio.com) manually
   1. [Install Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) for VS Code
   1. Get Gist Token from secret hiding place
   1. Type `sync` in the Command Palette in VS Code and copy/paste your GitHub token and Gist ID
   1. Wait for all your extensions and themes to sync up and then close VS Code
1. Using GitBash, clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles && git checkout windows`

### Run the `new-computer.ps1` script

1. Open PowerShell as admin and enable script execution: `Set-ExecutionPolicy RemoteSigned`
1. Allow .NET packages to be installed via NuGet: `Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`
1. Install Chocolatey: `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
1. Close and re-open PowerShell as admin
1. Then execute the `new-computer.ps1` script in order to install and configure all the things: `.\new-computer.ps1`

### Finish up

The following installations require special params during installation thus they are not included in `new-computer.ps1`

1. [Install Ubuntu](https://www.microsoft.com/en-CA/store/p/ubuntu/9nblggh4msv6?rtc=1) from the Windows App Store
1. Open Bash (in Windows 10) and symlink Ubuntu's `.bashrc` to the `.bashrc` in this repo. It'll be something like: `ln -s /mnt/c/Users/jonat/.dotfiles/bash/.bashrc /home/jonathan/.bashrc`
1. [Install Ruby](https://chocolatey.org/packages/ruby)
1. Install Photoshop manually
1. Install Lightroom manually
1. Install Premier manually
1. Uninstall OneDrive
1. Uninstall unwanted apps by right-clicking them in the Start Menu

## (L)ubuntu

1. Install Lubuntu
1. [Install Dropbox](https://www.linuxbabe.com/cloud-storage/install-dropbox-ubuntu-16-04)
1. Setup SSH keys
   * Copy (or [generate](https://help.github.com/articles/generating-ssh-keys/)) server keys from your secret hiding place to ~/.ssh (example: `cd secret/path && cp id_rsa ~/ssh/id_rsa`)
   * Ensure correct permissions on your .ssh directory and your keys: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa`
   * For help with GitHub SSH keys see: [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/)
1. Install Git: `sudo apt-get install git`
1. [Install VS Code](https://code.visualstudio.com/docs/setup/linux)
1. Clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the new computer script

```bash
# Make the new-computer.bash script executable.
cd ~/.dotfiles && chmod +x new-computer.bash

# Install and configure *a lot* of software.
./new-computer.bash
```

### After running the new computer setup script

1. Set desktop preferences (panel postitions, etc.)
1. Set folder and file browser preferences (folder size, etc.)
1. Uninstall pre-packaged OS software that's not useful (such as games)
1. [Install Hyper](https://github.com/zeit/hyper/releases)

## All systems

### Git config

Run the `git-config.bash` script with Git Bash on Windows or Bash on Ubuntu: `chmod +x ~/.dotfiles/git/git-config.bash && ~/.dotfiles/git/git-config.bash`

### Install Apache, PHP, MySQL and Composer

1. Install Apache
   * [Windows](https://chocolatey.org/packages/apache-httpd): `choco install apache-httpd --params '"/installLocation:C:\HTTPD /port:433"'`
   * [Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04): `sudo apt-get install apache2`
1. Install PHP (`php --ini` displays current PHP configuration)
   * [Windows](https://chocolatey.org/packages/php): `choco install php --params '"/ThreadSafe ""/InstallDir:C:\PHP"""'`
   * [Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04): `sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql`
1. Install MySQL
   * [Windows](https://chocolatey.org/packages/mysql): `choco install mysql`
   * [Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04): `sudo apt-get install mysql-server`
1. Install Composer
   * [Windows](https://chocolatey.org/packages/composer): `choco install composer`
   * [Ubuntu](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx)
