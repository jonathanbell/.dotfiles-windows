# .dotfiles

These are my config files and setup procedures for a new computer. This is the Windows branch, so use these instructions on Windows. For Ubuntu, see the Ubuntu branch. Fork if you wish but know that some of these configurations are pretty personalized to me.

Inspired by: <https://dotfiles.github.io/> and <https://github.com/jayharris/dotfiles-windows>

## Setup a New Computer: Install all the Softwares

1. Install Windows
1. Install Dropbox
1. [Install Chrome](https://www.google.com/chrome/browser/desktop/index.html)
   1. Sign in to Chrome
1. [Download and install Source Code Pro](https://fonts.google.com/specimen/Source+Code+Pro?selection.family=Source+Code+Pro)
1. [Install Git](https://git-scm.com/download/win)
1. [Install Meld](http://meldmerge.org/)
   1. Set `meld` in your `PATH` (by editing your Enviroment Variables)
1. [Install C++](https://www.microsoft.com/en-us/download/details.aspx?id=48145)
1. [Install cUrl](https://curl.haxx.se/download.html)
1. [Install VS Code](https://code.visualstudio.com)
   1. [Install Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
   1. Get Gist Token from secret hiding place
   1. Type `sync` in the Command Palette and copy/paste your GitHub token and Gist ID
   1. Wait for all your extensions and themes to sync up and then close VS Code
1. [Enable the Linux Subsystem for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
   1. Restart computer
   1. From the Windows store, search for and install Ubuntu
1. [Install Heroku Command Line](https://devcenter.heroku.com/articles/heroku-command-line#download-and-install)
1. [Install NodeJS](https://nodejs.org/en/download/)
1. Clone this repo into your home folder and checkout the `windows` branch: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles && git checkout windows`
1. Open Bash (in Windows 10) and symlink Ubuntu's `.bashrc` to the `.bashrc` in this repo! It'll be something like: `ln -s /mnt/c/Users/jonat/.dotfiles/bash/.bashrc /home/jonathan/.bashrc`

### Run the New Computer Script

1. Open PowerShell as admin
1. Ensure that local scripts and remote, digitally signed ones may be executed: `Set-ExecutionPolicy RemoteSigned`
1. Then launch the new computer script: `.\new-computer.ps1`

### After Running the New Computer Setup Script

Post installation things to do (optional):

1. Configure Apache and/or Nginx, MySQL, and PHP
   1. Setup PHP ini file to display errors (`php --ini`)
   1. [Configure your hosts file](https://www.petri.com/easily-edit-hosts-file-windows-10) for local development
1. [Install Composer](https://getcomposer.org/download/)
