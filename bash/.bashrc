# determine the system OS: http://stackoverflow.com/a/8597411/1171790
# stuff to do on a Linux/Ubuntu or Mac system...
if [ "$OSTYPE" = "linux-gnu" ] || [ "$OSTYPE" = "darwin"* ]; then

	# change directory to working folder for web projects
	if [ -d "$HOME/Dropbox/Sites/_devel" ]; then
		cd $HOME/Dropbox/Sites/_devel;
	fi

	# shortcuts
	alias dot="cd ~/.dotfiles"
	alias sublimedir="cd ~/.config/sublime-text-3/Packages/User"
	alias restartapache="sudo service apache2 restart"
	alias l="ls -laF ${colorflag}"
	alias d="cd ~/Dropbox"
	alias s="cd ~/Dropbox/Sites"
	alias small="export PS1=\"\$ \""
  alias hosts="sudo nano /etc/hosts"
  alias configapache="sudo subl /etc/apache2/apache2.conf"

  # colored output when using ls
	ls --color=al > /dev/null 2>&1 && alias ls='ls -F --color=al' || alias ls='ls -G'

	# make sure we have a good screen gamma setup for long hours of staring at the screen
	echo "Setting screen gama..."
	xgamma -gamma 0.91
	echo

	echo "Dropbox Status:"
	dropbox status
	echo

fi # end if Ubuntu/Mac

# make sublime text the default editor
export EDITOR='subl';

# omit duplicates from bash history and commands that begin with a space
export HISTCONTROL='ignoreboth';

# prefer US English and use UTF-8
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# append to the Bash history file, rather than overwriting it
shopt -s histappend;

# autocorrect typos in path names when using `cd`
shopt -s cdspell;

# don't prompt for merge_msg in git
export GIT_MERGE_AUTOEDIT=no

# show Git branch and current working directory in Bash
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# this PS1 shows something like: ~/.dotfiles (master) $  
# export PS1="\[\033[31m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \$ "

# shows something like (with colored backgrounds): .dotfiles (master) $ 
export PS1="\[$(tput bold)\]\[\033[46m\]\W\[$(tput bold)\]\[\033[101m\]\$(parse_git_branch)\[\033[00m\] $ "

# added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
