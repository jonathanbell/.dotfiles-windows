# .dotfiles

These are my configuration files and setup scripts for new computers. I primarily use Windows 10 and Lubuntu/Ubuntu. In most cases these [dotfiles](https://dotfiles.github.io) will work on those systems. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

**Table of Contents**

<!-- TOC -->

- [Setup a Windows 10 computer](#setup-a-windows-10-computer)
  - [Run the `new-computer.ps1` script](#run-the-new-computerps1-script)
  - [Finish up](#finish-up)
- [Setup a (L)Ubuntu-based computer](#setup-a-lubuntu-based-computer)
  - [Run the `new-computer.bash` script](#run-the-new-computerbash-script)
  - [After running the new computer setup script](#after-running-the-new-computer-setup-script)
- [Manual configurations (all systems)](#manual-configurations-all-systems)
  - [Cloudinary](#cloudinary)
  - [Apache](#apache)
    - [Finally:](#finally)
  - [MySQL](#mysql)

<!-- /TOC -->

---

## Setup a Windows 10 computer

1.  Install Windows
1.  Install and configure all additional hardware-specific Windows drivers (usually found on your backup drive)
1.  [Install Dropbox](https://www.dropbox.com/install) manually
1.  [Install GitBash](https://git-scm.com/download/win) manually
1.  Open a PowerShell as an administrator and set your ExecutionPolicy: `Set-ExecutionPolicy RemoteSigned`
1.  Allow .NET packages to be installed via NuGet: `Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force`
1.  Install Chocolatey from a privileged PowerShell: `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
1.  Close PowerShell
1.  [Install C++ 2015](https://www.microsoft.com/en-us/download/details.aspx?id=48145) manually (this is a VS Code dependency)
1.  [Install VS Code](https://code.visualstudio.com) manually
    1.  [Install Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) for VS Code
    1.  Get Gist Token from secret hiding place
    1.  Type `sync` in the Command Palette in VS Code and copy/paste your GitHub token and Gist ID
    1.  Wait for all your extensions and themes to sync up and then close VS Code (your text editor is ready to roll!)
1.  Using GitBash, clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the `new-computer.ps1` script

1.  Open PowerShell as an admin
1.  Change directory your .dotfiles directory: `cd $HOME\.dotfiles`
1.  Then execute the `new-computer.ps1` script in order to install and configure **all** the things: `.\new-computer.ps1`

### Finish up

The following instructions cannot be scripted via PowerShell and should be done manually.

1.  [Install Ubuntu on Windows 10](https://www.microsoft.com/en-CA/store/p/ubuntu/9nblggh4msv6?rtc=1) from the Windows App Store
1.  Open Bash (in Windows 10) and symlink Ubuntu's `.bashrc` to the `.bashrc` inside this repo. The command will be something like: `ln -s /mnt/c/Users/jonat/.dotfiles/bash/.bashrc /home/jonathan/.bashrc` (the Windows C drive ends up being mounted at `/mnt/c/` by default)
1.  Install Photoshop manually
1.  Install Lightroom manually
1.  Install Premier manually
1.  [Install MovesLink](http://www.movescount.com/connect/download?type=moveslink) manually
1.  Uninstall unwanted apps by right-clicking them in the Start Menu
1.  Setup SSH/Rsync on the Linux subsystem by copying your SSH `config` file to the home directory of your Linux subsytem. To find that path you can, run `ubuntuhome` from the GitBash command line.
1.  Edit the paths inside the newly copied Linux subsystem SSH `config` file.
1.  In a PowerShell with elevated privileges: `cd $HOME\.dotfiles\powershell`
1.  As per the instructions [here](https://github.com/neilpa/cmd-colors-solarized#update-command-prompt-and-powershell-shortcut-lnks), search for `bash` at Windows start menu and copy the path to that executable.
1.  Then run `.\Update-Link.ps1 <copied path from above> dark` inside `~/.dotfiles/powershell`
1.  _Optional_: You may need to setup permissions for SSH keys to work correctly on the Linux/Windows Subsystem. [Edit `/etc/wsl.conf`](https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/) (add it if it does not exist) using the following code block and then change the permissions of the private key directory to `700` and all the keys inside the directory to `600`.

```ini
[automount]                                                                                                                                             enabled = true                                                                                                                                          options = "metadata,umask=22,fmask=11"                                                                                                           mountFsTab = false
```

---

## Setup a (L)Ubuntu-based computer

TODO: Edit/update this section

1.  Install Lubuntu
1.  [Install Dropbox](https://www.linuxbabe.com/cloud-storage/install-dropbox-ubuntu-16-04)
1.  Setup SSH keys
    1.  Copy (or [generate](https://help.github.com/articles/generating-ssh-keys/)) server keys from your secret hiding place to ~/.ssh (example: `cd secret/path && cp id_rsa ~/ssh/id_rsa`)
    1.  Ensure correct permissions on your .ssh directory and your keys: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa` For help with GitHub SSH keys see: [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/)
1.  Install Git: `sudo apt-get install git`
1.  [Install VS Code](https://code.visualstudio.com/docs/setup/linux)
1.  Clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the `new-computer.bash` script

TODO: Edit/update this section

```bash
# Make the new-computer.bash script executable.
cd ~/.dotfiles && chmod +x new-computer.bash

# Install and configure *a lot* of software.
./new-computer.bash
```

### After running the new computer setup script

TODO: Edit/update this section

1.  Set desktop preferences (panel positions, etc.)
1.  Set folder and file browser preferences (folder size, etc.)
1.  Uninstall pre-packaged OS software that's not useful (such as games)
1.  [Install Hyper](https://github.com/zeit/hyper/releases)

---

## Manual configurations (all systems)

### Cloudinary

1.  Create a Cloudinary configuration file: `touch $HOME/.cloudinary`
1.  Visit: <https://cloudinary.com/console> and copy your API key and secret
1.  Add your Cloudinary credentials to `.cloudinary` in the following format:

```json
{
  "cloud_name": "sample",
  "api_key": "874837483274837",
  "api_secret": "a676b67565c6767a6767d6767f676fe1"
}
```

See: <https://www.npmjs.com/package/cloudinary-cli#global-config> for more information. You can now [upload images to Cloudinary](https://www.npmjs.com/package/cloudinary-cli#upload) with `cloudinary upload foo.png`

### Apache

Make these changes to `httpd.conf`:

1.  Change the `Listen` directive to allow localhost traffic only by adding/changing [`Listen 127.0.0.1:8080`](https://serverfault.com/a/276968/325456) and `Listen 127.0.0.1:443`
1.  `ServerName localhost:8080`
1.  Edit `DocumentRoot` section and the first `<Directory>` entry to point to your projects root folder
    1.  Also ensure that `AllowOverride` is set to `All` (in order to allow `.htaccess` files to do their thing)
1.  Ensure that `mod_rewrite` and `mod_expires` are enabled/uncommented
1.  Make sure this line is uncommented: `Include conf/extra/httpd-vhosts.conf`
1.  Ensure `DirectoryIndex` has `index.php` as a value
1.  _If Windows_: Copy/paste [the following code block](https://brian.teeman.net/joomla/install-amp-on-windows-with-chocolatey) to the bottom of `httpd.conf` in order to ensure that Apache calls PHP when a request is made.

```apache
# PHP handler for Apache installed via Chocolatey on Windows
AddHandler application/x-httpd-php .php
AddType application/x-httpd-php .php .html
LoadModule php7_module "C:/tools/php72/php7apache2_4.dll"
PHPIniDir "C:/tools/php72"
```

Then, setup localhost to use a self-signed SSL certificates for each web project by placing a `<VirtualHost>` entry into `httpd-vhost.conf` for each local project app/site. Use the following code block as a guide:

```apache
<VirtualHost *:443>
  DocumentRoot "C:/Users/you/Sites/yoursite.com/public"
  ServerName dev.yoursite.com
  SSLEngine on
  SSLCertificateFile "C:/Users/you/AppData/Roaming/Apache24/conf/ssl/server.crt"
  SSLCertificateKeyFile "C:/Users/you/AppData/Roaming/Apache24/conf/ssl/server.key"
  ErrorLog "C:/Users/you/Sites/_dev/logs/dev.yoursite.com-error.log"
  CustomLog "C:/Users/you/Sites/_dev/logs/dev.yoursite.com-access.log" common
</VirtualHost>
```

#### Finally:

1.  Add your virtual hosts to `httpd-vhosts.conf`
1.  Edit your `hosts` file (_Windows_: `C:\Windows\System32\drivers\etc\hosts`; _Linux_: `/etc/hosts`) in order to point local development sites to `127.0.0.1`

### MySQL

1.  [Set the root password for MySQL](https://brian.teeman.net/joomla/install-amp-on-windows-with-chocolatey)
    1.  Logon to MySQL: `mysql -u root`
    1.  Once logged in, set the root password: `ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';`
1.  Log into MySQL again (`mysql -u root -p`) in order to confirm that everything is running as expected (for example, run: `show databases`)
