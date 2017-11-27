#!/bin/bash

# ------------------------------------------------------------------------------
# | Functions # http://stackoverflow.com/a/6347145
# ------------------------------------------------------------------------------

# Checks if a package is installed. If it is not, function installs it.
installifnotinstalled() {
  command -v $1 >/dev/null 2>&1 || {
    echo "$1 is not installed. Installing $1..." >&2;
    sudo apt-get install -y "$1";
  }
}

# Syslink a dotfile file to the location where it is normally located.
# Removes the original file if one exists.
link() {
  from="$1"
  to="$2"
  echo "Linking $from to $to"
  rm -f "$to"
  ln -s "$from" "$to"
}

# ------------------------------------------------------------------------------

# Check if this script is running on a Linux system.
if ! [ "$OSTYPE" = "linux-gnu" ]; then
  echo "You are not using a Linux computer. Run this script on Linux with Ubuntu or Lubuntu, please."
  exit
else
  # OK, the script is running on Linux.
  # Now check if we have 'gawk'.
  command -v gawk >/dev/null 2>&1 || { echo "Please enter your password so that I can install gawk..." >&2; sudo apt-get install -y gawk; }
  # Now that we have 'gawk', we can check if this flavour of Linux is Ubuntu.
  OPERATINGSYSTEM=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
  if [ ! "$OPERATINGSYSTEM" = "\"Ubuntu\"" ]; then
    echo "This script is meant to be run on an Ubuntu based system with \"apt-get\" available."
    echo "Exiting..."
    exit
  fi
fi

# OK, looks like we have the enviroment we are expecting.. Proceed.

# Update current packages?
read -p "Before installing some new software packages, do you want to update your existing system? (Y/n?) " choice
case "$choice" in
  y|Y ) echo; echo "Sure, why not eh?!"; sudo apt-get update -y; sudo apt-get upgrade -y; sudo apt-get autoremove -y;;
  n|N ) echo; echo "OK."; echo;;
  * ) echo "Invalid response. Choose Y or N next time, bro."; echo "Exiting..."; exit;;
esac

# Install all the softwares.
PACKAGES=( gnome-terminal curl nodejs meld pgadmin3 skypeforlinux youtube-dl imagemagick xclip wget npm trimage ffmpeg apache2 mysql-server mysql-client php mysql-workbench sqlite3 sqlitebrowser libapache2-mod-php php-mcrypt php-mysql php-cli ruby rubygems python-pip )
for i in "${PACKAGES[@]}"
do
  installifnotinstalled "$i"
done

# On Ubuntu, 'node' is not 'node' until it's linked to 'nodejs' ¯\_(ツ)_/¯
# https://github.com/nodejs/node-v0.x-archive/issues/3911#issuecomment-8956154
sudo ln -s /usr/bin/nodejs /usr/bin/node
echo

# Setup Numix theme for use on Ubuntu.
echo "-------Setup Ubuntu-------"
sudo add-apt-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install numix-gtk-theme numix-icon-theme numix-icon-theme-square
echo

# TODO: Remove/uninstall packages that come with (L)ubuntu that we don't want.

# Setup Bash.
echo "-------Setup Bash-------"
for file in `ls -A ./bash`
do
  # Link Bash dotfiles.
  link "`pwd`/bash/$file" "$HOME/$file"
done
echo

# Setup Git.
# Is Git installed?
command -v git >/dev/null 2>&1 || { echo "Git is not installed. Please install it before proceeding." >&2; echo "Exiting..."; exit; }
# Remove existing config, we'll overwrite it below.
rm -f ~/.gitconfig
rm -f ~/.gitignore_global
echo "-------Setup Git-------"
# Instead of syslinking the files, we simply tell git directly where our global config files are located:
git config --global core.excludesfile "`pwd`/git/.gitignore_global"
git config --global core.attributesfile "`pwd`/git/.gitattributes"
echo "Configuring .gitconfig file..."
# Using the --global option will write the values to a global file (~/.gitconfig).
# Alternatively, I guess we could syslink a .gitconfig file to a .gitconfig file in this repo (.dotfiles/git/.gitgonfig).
# http://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup#Your-Identity
git config --global user.name "Jonathan Bell"
# https://gist.github.com/trey/2722934#bonus
git config --global user.email jonathanbell.ca@gmail.com
# Set VS Code as the core text editor.
git config --global core.editor code
# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf input
# Fix whitespace isssues. http://stackoverflow.com/a/2948167/1171790
git config --global core.whitespace fix
# But don't warn about whitespace, thanks.
git config --global apply.whitespace nowarn
# Allow all Git commands to use colored output.
git config --global color.ui true
# https://gist.github.com/trey/2722934
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto
git config --global color.ui true
git config --global color.pager true
# Push only the current branch to remote (same as what a 'git pull' would use).
# Note that the remote branch *could* possibly have a different name than yours.
# https://git-scm.com/docs/git-config.html#git-config-branchltnamegtremote
git config --global push.default current
# Accept the auto-generated merge message.
# https://git-scm.com/docs/merge-options#merge-options---no-edit
git config --global core.mergeoptions --no-edit
echo

# Setup Meld as our difftool and mergetool.
# Make the Meld diff script executable.
chmod +x "`pwd`/meld/git-diff.sh"
echo "-------Setup Meld-------"
# Set Meld as the default GUI difftool.
git config --global diff.guitool meld
git config --global diff.tool meld
git config --global diff.external "`pwd`/meld/git-diff.sh"
# Don't prompt after saving the file(s) in Meld.
git config --global difftool.meld.prompt false
echo "Set Meld as the Git difftool."
# Set Meld as the Git mergetool.
git config --global merge.tool meld
git config --global mergetool.meld.keepBackup false
git config --global mergetool.keepBackup false
git config --global mergetool.meld.keepTemporaries false
git config --global mergetool.keepTemporaries false
echo "Set Meld as the Git mergetool."
echo

# Install Heroku Toolbelt.
# https://devcenter.heroku.com/articles/heroku-command-line#download-and-install
command -v heroku >/dev/null 2>&1 || { echo "-------Setup Heroku-------" >&2; wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh; }

echo
echo "All done. Your softwares are installed! :)"
echo
echo "Your NodeJS version is: $(node -v)"
echo "Your npm version is: $(npm -v)"
echo "Do: 'git config --list' to view your Git configuration."
echo
read -p "But wait! There's still a little bit more to do manually! Open the README? (Y/n?) " choice
case "$choice" in
  y|Y ) xdg-open "https://github.com/jonathanbell/.dotfiles#after-running-the-new-computer-setup-script"; echo;;
  * ) echo "A reboot may be in order. Enjoy your new computer! :)";;
esac
echo

exit
