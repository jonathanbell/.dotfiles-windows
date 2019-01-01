# .dotfiles

These are my configuration files and setup scripts for new Windows computers. I primarily use Windows 10 with the Ubuntu Windows Linux Subsystem. In most cases these [dotfiles](https://dotfiles.github.io) will work on similar systems. Fork if you wish but keep in mind that a lot of these settings are personalized to me (so you will most likely want to change them before using the scripts). Review the code, and remove things you don't want or need. Do not blindly use these settings.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

**Table of Contents**

<!-- TOC -->

- [Setup a Windows 10 computer](#setup-a-windows-10-computer)
  - [Run the `new-computer.ps1` script](#run-the-new-computerps1-script)
  - [Run the `new-computer.bash` script](#run-the-new-computerbash-script)
  - [Optional: Extra stuff](#optional-extra-stuff)
    - [Cloudinary](#cloudinary)
    - [Apache](#apache)

<!-- /TOC -->

---

## Setup a Windows 10 computer

1.  Install Windows
1.  Install and configure all additional hardware-specific Windows drivers (usually found on your backup drive or in the cloud)
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
1.  [Install Ubuntu on Windows 10](https://www.microsoft.com/en-CA/store/p/ubuntu/9nblggh4msv6?rtc=1) from the Windows App Store
1.  [Set your Ubuntu/Linux home directory to be the same as your Windows home folder](https://superuser.com/a/1134645/116082)
1.  Install Photoshop manually
1.  Install Lightroom manually
1.  Install Premier manually
1.  [Install MovesLink](http://www.movescount.com/connect/download?type=moveslink) manually
1.  Uninstall unwanted apps by right-clicking them in the Start Menu
1.  Copy (or symlink) SSH `config` file from your secret hiding place to `~/.ssh` or [setup new ones](https://gist.github.com/jonathanbell/bbb4468cf7bc6c0bb585d3b9c751e37d).
    1. From the Linux command line `ln -s /path/to/secret/hiding/place ~/.ssh`
1.  _Optional_: You may need to setup permissions for SSH keys to work correctly on the Linux/Windows Subsystem. [Edit `/etc/wsl.conf`](https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/) (add it if it does not exist) using the following code block and then change the permissions of the private key directory to `700` and all the keys inside the directory to `600`.

### Run the `new-computer.ps1` script

1.  Open PowerShell as an admin
1.  Change directory your .dotfiles directory: `cd $HOME\.dotfiles`
1.  Then execute the `new-computer.ps1` script in order to install and configure **all** the Windows things: `.\new-computer.ps1`

### Run the `new-computer.bash` script

The following instructions are meant to be run inside the Windows Subsystem for Linux command line. Open that command prompt and run:

1. `cd ~/.dotfiles && chmod +x new-computer.bash`
1. `./new-computer.bash`

---

### Optional: Extra stuff

#### Cloudinary

1.  Copy your Cloudinary config file from your secret hiding place to `~/.cloudinary`

You can now [upload images to Cloudinary](https://www.npmjs.com/package/cloudinary-cli#upload) with `cloudinary upload foo.png`

#### Apache

1. Enable/give priority to `.php` files: `sudo nano /etc/apache2/mods-enabled/dir.conf` and move `index.php` to the front of the list.
1. Open `ports.conf`: `cd /ect/apache2 && sudo nano ports.conf` and make these changes:
   1. Change the default port (80) to 8080
1. Open `apache2.conf`: `sudo nano apache2.conf` and make the following changes:
   1. Add `AcceptFilter http none` and `AcceptFilter https none` to the end of the file.
   1. Change `<Directory /var/www/>` to `<Directory /mnt/c/Users/path/to/your/sites>`
   1. Also ensure that `AllowOverride` is set to `All` (in order to allow `.htaccess` files to do their thing)
1. For each locally hosted website that you have, add a `<VirtualHost>` entry to `000-default.conf`: `cd sites-enabled && sudo nano 000-default.conf`.
   1. For each site, copy+paste the block below and edit it to suit your needs:
   ```apache
   <VirtualHost *:443>
      DocumentRoot "/mnt/c/Users/<your username>/path/to/site"
      ServerName dev.localhost.com # change to whatever you like
      SSLEngine on
      SSLCertificateFile "/etc/ssl/certs/ssl-cert-snakeoil.pem"
      SSLCertificateKeyFile "/etc/ssl/private/ssl-cert-snakeoil.key"
      ErrorLog "/mnt/c/Users/<your username>/path/to/error/logs"
      CustomLog "/mnt/c/Users/<your username>/path/to/custom/logs" common
   </VirtualHost>
   ```
1. [Edit the `hosts` file on the Windows side of things.](https://support.rackspace.com/how-to/modify-your-hosts-file/#windows) The file will be located in `C:\Windows\System32\Drivers\etc\`.
   1. Add your local domain like so: `127.0.0.1 dev.localhost.com`
1. Ensure that `mod_rewrite` and `mod_expires` are enabled: `sudo cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && sudo cp /etc/apache2/mods-available/expires.load /etc/apache2/mods-enabled/expires.load`
1. Finally, ensure permissions are correct on the directory where you keep your website code: `sudo chmod 775 -R /mnt/c/Users/<your username>/path/to/websites/`
