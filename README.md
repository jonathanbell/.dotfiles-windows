# .dotfiles

These are my config files and setup procedures for a new computer. They'll work best on a computer with [Lubuntu](http://lubuntu.net/) installed because that's what I use. Fork them if you wish.

Inspired by: [https://dotfiles.github.io/](https://dotfiles.github.io/)

## Setup a New Computer: Install all the Softwares

1. Install Lubuntu
1. [Install Dropbox](https://www.linuxbabe.com/cloud-storage/install-dropbox-ubuntu-16-04)
1. Setup SSH keys
    - Copy (or [generate](https://help.github.com/articles/generating-ssh-keys/)) server keys from your secret hiding place to ~/.ssh (example: `cd secret/path && cp id_rsa ~/ssh/id_rsa`)
    - Ensure correct permissions on your .ssh directory and your keys: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa`
    - For help with GitHub SSH keys see: [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/)
1. Install Git: ```sudo apt-get install git```
1. [Install VS Code](https://code.visualstudio.com/docs/setup/linux)
1. Clone this repo into your home folder: `cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles`

### Run the New Computer Script

```bash
# Make the new-computer.bash script executable.
cd ~/.dotfiles && chmod +x new-computer.bash

# Install and configure *a lot* of software.
./new-computer.bash
```

### After Running the New Computer Setup Script

Now tidy up, by doing the following:

1. Set desktop preferences
1. Set folder and file browser preferences
1. [Configure Apache and/or Nginx, MySQL, and PHP](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04)
    - Setup PHP ini file to display errors (`php --ini`)
    - Configure your hosts file for local development: `sudo nano /etc/hosts`
1. Uninstall pre-packaged OS software that's not useful (such as games, but keep Chess!)
