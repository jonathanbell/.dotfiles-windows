#!/bin/bash

# ------------------------------------------------------------------------------
# | Functions # http://stackoverflow.com/a/6347145
# ------------------------------------------------------------------------------

# Checks if a package is installed. If it is not, the function installs it.
installifnotinstalled() {
  command -v $1 >/dev/null 2>&1 || {
    echo "$1 is not installed. Installing $1..." >&2;
    sudo apt install -y "$1";
  }
}

# ------------------------------------------------------------------------------

# Check if this script is running on a Linux system.
if ! [ "$OSTYPE" = "linux-gnu" ]; then
  echo "You are not using a Linux computer. Run this script on a Linux system with Ubuntu or Lubuntu installed."
  exit
else
  # OK, the script is running on Linux.
  # Now check if we have 'gawk'.
  command -v gawk >/dev/null 2>&1 || { echo "Please enter your password so that I can install gawk..." >&2; sudo apt install -y gawk; }
  # Now that we have 'gawk', we can check if this flavour of Linux is Ubuntu.
  OPERATINGSYSTEM=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
  if [ ! "$OPERATINGSYSTEM" = "\"Ubuntu\"" ]; then
    echo "This script is meant to be run on an Ubuntu based system with \"apt\" available."
    echo "Exiting..."
    exit
  fi
fi

# OK, looks like we have the enviroment we are expecting.. Proceed.

# Update current packages?
read -p "Before installing some new software packages, do you want to update your existing system? (Y/n?) " choice
case "$choice" in
  y|Y ) echo; echo "Sure, why not eh?!"; sudo apt update -y; sudo apt upgrade -y; sudo apt autoremove -y;;
  n|N ) echo; echo "OK."; echo;;
  * ) echo "Invalid response. Choose Y or N next time, bro."; echo "Exiting..."; exit;;
esac

# Install all the softwares.
echo "-------Setup a lot of software...-------"
PACKAGES=(
  apache2
  curl
  git
  ffmpeg
  imagemagick
  mysql-server
  mysql-client
  nodejs
  php
  libapache2-mod-php
  php-cli
  php-curl
  php-ldap
  php-openssl
  php-mbstring
  php-mcrypt
  php-mysql
  php-xml
  python3-pip
  ruby
  rubygems
  sqlite3
  wget
  xclip
  unzip
  gifsicle
  youtube-dl
)

for i in "${PACKAGES[@]}"
do
  installifnotinstalled "$i"
done

# On Ubuntu, 'node' is not 'node' until it's linked to 'nodejs' ¯\_(ツ)_/¯
# https://github.com/nodejs/node-v0.x-archive/issues/3911#issuecomment-8956154
sudo ln -s /usr/bin/nodejs /usr/bin/node
echo

# Enable SSL w/ Apache
sudo a2enmod ssl

# Install AWS CLI
echo "-------Setup AWS and B2 CLI-------"
pip install --upgrade pip
pip install awscli --upgrade --user
sudo apt install awscli
# Install Backblaze just because..
sudo pip install --upgrade --ignore-installed b2

# Install Composer
echo "-------Setup Composer-------"
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer --version

# Install global NPM packages
echo "-------Setup NPM-------"
NPMPACKAGES=(
  cloudinary-cli
  create-react-app
  gatsby-cli
  gatsby
  sass
  surge
)

# https://stackoverflow.com/a/41395398/1171790
mkdir ~/.npm-global
export NPM_CONFIG_PREFIX=~/.npm-global
export PATH=$PATH:~/.npm-global/bin

npm i -g npm

for i in "${NPMPACKAGES[@]}"
do
  npm i -g "$i"
done

# Setup Git.
echo "-------Setup Git-------"
cd ~/.dotfiles
chmod +x ./git/git-config.bash
./git/git-config.bash

echo
echo "All done. Your softwares are installed! :)"
echo
echo "Your NodeJS version is: $(node -v)"
echo "Your npm version is: $(npm -v)"
echo "`git config --list` will display your Git configuration."
echo

exit
