#!/bin/bash

# checks if a package is installed. if it is not, installs it.
installifnotinstalled() {
  command -v $1 >/dev/null 2>&1 || {
    echo "$1 is not installed. Installing $1..." >&2;
    sudo apt-get install -y "$1";
  }
}

# check if Linux
if [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "win32" ] || [ "$OSTYPE" = "darwin"* ]; then
  echo "You are not using a Linux machine. Run this script on Ubuntu please, bro."
  exit
else
  # OK, it's Linux
  # check if we have gawk
  command -v gawk >/dev/null 2>&1 || { echo "Please enter your password so that I can install gawk..." >&2; sudo apt-get install -y gawk; }
  # we have gawk. check if we are on Ubuntu.
  OPERATINGSYSTEM=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
  if [ ! "$OPERATINGSYSTEM" = "\"Ubuntu\"" ]; then
    echo "This script is meant to be run on a Debian based system with apt-get (such as Ubuntu)."
    exit
  fi
fi

read -p "Before installing some dotfile packages, do you want to update all packages on Ubuntu? (Y/n?) " choice
case "$choice" in
  y|Y ) echo; echo "Sure, why not eh?!"; sudo apt-get update -y; sudo apt-get upgrade -y; sudo apt-get autoremove -y;;
  n|N ) echo; echo "OK."; echo;;
  * ) echo "Invalid response. Choose Y or N next time, bro.";;
esac

# install all these packages
PACKAGES=( curl nodejs meld wget npm trimage apache2 mysql-server mysql-client php libapache2-mod-php php-mcrypt php-mysql php-cli php-curl ruby )
for i in "${PACKAGES[@]}"
do
  installifnotinstalled "$i"
done

# https://github.com/nodejs/node-v0.x-archive/issues/3911#issuecomment-8956154
sudo ln -s /usr/bin/nodejs /usr/bin/node

# make syslinks for dotfiles to the locations where they normally are kept.
# remove the 'original file' if one exists.
link() {
  # http://stackoverflow.com/a/6347145
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}
echo

# Bash
echo "-------Setup Bash-------"
for file in `ls -A ./bash`
do
  link "`pwd`/bash/$file" "$HOME/$file"
done
echo

# LXTerminal
echo "-------Setup Terminal-------"
link "`pwd`/terminal/lxterminal.conf" "$HOME/.config/lxterminal/lxterminal.conf"
echo

# Sublime Text
# if Sublime Text is installed then link config files to sublime directory
command -v subl >/dev/null 2>&1 || { echo "Sublime Text is not installed. Please install it before proceeding." >&2; exit; }
echo "-------Setup Sublime Text-------"
# remove existing sublime user folder
rm -rf $HOME/.config/sublime-text-3/Packages/User
# link the Sublime User directory to the dotfiles Sulime User directory
ln -s "`pwd`/sublime/User" "$HOME/.config/sublime-text-3/Packages/User"
echo "Linked Sublime Text config files to ~/.dotfiles/sublime/User"
echo

# Git
# is Git installed? http://stackoverflow.com/a/4785518/1171790
command -v git >/dev/null 2>&1 || { echo "Git is not installed. Please install it before proceeding." >&2; exit; }
# remove existing config, we'll overwrite it below.
rm -f ~/.gitconfig
rm -f ~/.gitignore_global
echo "-------Setup Git-------"
# we simply tell git directly where our global config files are located:
git config --global core.excludesfile "`pwd`/git/.gitignore_global"
git config --global core.attributesfile "`pwd`/git/.gitattributes"
echo "Configuring your .gitconfig file..."
# using the --global option will just write these values to a ~/.gitconfig file
# setup user.name and email (below) - you'll want to change these to your own :)
# http://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup#Your-Identity
git config --global user.name "Jonathan Bell"
# https://gist.github.com/trey/2722934#bonus
git config --global user.email jonathanbell.ca@gmail.com
# set Sublime Text as the core text editor
git config --global core.editor subl
# setup autocrlf line endings. 
# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf input
# don't warn about whitespace
git config --global apply.whitespace nowarn
# http://stackoverflow.com/a/2948167/1171790
git config --global core.whitespace nowarn
# allow all Git commands to use colored output
git config --global color.ui true
# https://gist.github.com/trey/2722934
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto
git config --global color.ui true
git config --global color.pager true
# push only current branch to remote branch that 'git pull' uses
# note that the remote branch *could* have a different name
# http://git-scm.com/docs/git-config.html
git config --global push.default current
git config --global core.mergeoptions --no-edit
echo

# Meld
# check if Meld is installed
command -v meld >/dev/null 2>&1 || { echo "Meld is not installed. Please install it before proceeding." >&2; exit; }
# make meld diff script executeable
chmod +x "`pwd`/meld/git-diff.sh"
echo "-------Setup Meld-------"
# set up Meld as the default gui diff tool
git config --global diff.guitool meld
git config --global diff.tool meld
git config --global diff.external "`pwd`/meld/git-diff.sh"
# don't prompt. saving the file in meld is a done deal.
git config --global difftool.meld.prompt false
echo "Setup Meld as the Git diff tool."
# set Meld as the mergetool
git config --global merge.tool meld
git config --global mergetool.meld.keepBackup false
git config --global mergetool.meld.keepTemporaries false
echo "Setup Meld as the Git merge tool."
echo

# Heroku
# https://devcenter.heroku.com/articles/heroku-command-line#download-and-install
command -v ruby >/dev/null 2>&1 || { echo "Ruby is not installed. Please install it before proceeding." >&2; exit; }
command -v heroku >/dev/null 2>&1 || { echo "-------Setup Heroku-------" >&2; wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh; }

echo "-------Config NPM-------"
sudo npm install -g jshint
sudo npm install -g sass-lint

echo
echo "Software installed!!!! :)"
echo
echo "Your NodeJS version is: $(node -v)"
echo "Your npm version is: $(npm -v)"
echo "Your Ruby version is: $(ruby -v)"
echo "Your Heroku CLI version is: $(heroku --version)"
echo "$ git config --list Will show your Git configuration."
echo
echo "Now do this stuff manually: https://github.com/jonathanbell/.dotfiles/blob/master/README.md#tidy-up-stuff-to-do-manually"
echo
