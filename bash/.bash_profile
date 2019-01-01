# https://github.com/Microsoft/WSL/issues/2067#issuecomment-299622057
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

# Use .bashrc instead. ---------------------------------------------------------

# Why I use .bashrc and not .bash_profile:
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html

# .bashrc is executed when you have already logged on to the machine. In other
# words, when you are already sitting at the computer. .bash_profile is executed
# if you logon over ssh or when you are not already logged on. So, I prefer to
# not execute anything here and place everything into .bashrc.

# If you wanted to try something potentially dangerous, you could put it here
# and not in .bashrc - then it would be easier to remove if it didn't work out.

# ------------------------------------------------------------------------------
