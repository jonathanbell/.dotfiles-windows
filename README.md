# .dotfiles

My config files and setup procedures for a new computer. Fork them if you wish. Inspired by: [https://dotfiles.github.io/](https://dotfiles.github.io/)

## Setting up a New Computer: Install the Softwares First

- [Install Dropbox](https://www.linuxbabe.com/cloud-storage/install-dropbox-ubuntu-16-04)
- Setup ~/.ssh (manual process for best security)
    - Copy (or [generate](https://help.github.com/articles/generating-ssh-keys/)) server keys from your secret hiding place to ~/.ssh (such as ~/ssh/id_rsa)
    - Ensure correct permissions: ```chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa```
    - For help with GitHub keys see: [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/)
- Install Git: ```sudo apt-get install git```
- [Install Sublime Text 3](https://www.google.ca/search?q=install+sublime+text+3+ubuntu)
    - [Install Package Control](https://packagecontrol.io/installation)
- Clone this repo into your home folder: ```cd ~ && git clone git@github.com:jonathanbell/.dotfiles.git && cd ~/.dotfiles```

### Run the Init Script

```
# make init_dotfiles.bash script executable
# then install and configure a *shwack* of software

cd ~/.dotfiles && chmod +x init_dotfiles.bash 
./init_dotfiles.bash
```

## Tidy Up (stuff to do manually)
- Setup desktop preferences 
- Setup folder preferences
- Copy ```./ubuntu/ubuntustartup.desktop``` to ```~/.config/autostart/``` and make ```ubuntustartup.desktop``` executable.
    - Make ```startup.bash``` executable: ```chmod +x ./ubuntu/startup.bash```
- [Configure Apache, MySQL, and PHP](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04)
    - Setup PHP ini file to display errors
    - Configure your hosts file for development: ```sudo nano /etc/hosts```
- Configure VirtualBox
- Uninstall pre-packaged OS software that's not useful to you 
- [Logon to Heroku](https://devcenter.heroku.com/articles/heroku-command-line#getting-started) via the Heroku CLI
