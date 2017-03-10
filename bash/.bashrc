# ------------------------------------------------------------------------------
# | Functions
# ------------------------------------------------------------------------------

# Displays current Git branch, if there is one.
function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Downloads mp3 audio file from YouTube video.
# Requires youtube-dl lib: http://www.tecmint.com/install-youtube-dl-command-line-video-download-tool/
function yt-getaudio() {
  if [ $# -eq 0 ]; then
    echo "Oops. Please enter a url. Usage: yt-getaudio <youtube-link>"
  else
  	echo "Starting YouTube download. Hit Enter after metadata added."
  	# --audio-quality [0-9]; 0 is best, 9 is worst.
    youtube-dl --extract-audio --audio-format mp3 --audio-quality 1 --embed-thumbnail --add-metadata $1
  fi
}

# Just a quick function to reduce an image's size in order to upload faster or whatever.
function shrink-image() {
	if [ $# -eq 0 ]; then
    echo "Oops. Please enter a filename. Usage: shrink-image <filename>"
  else
    convert -resize 50% $1 $1
  fi
}

# Quickly resize an image to a given width.
function resize-image-width() {
	if [ $# -ne 2 ]; then
		echo "Oops. Please enter filename and desired width. Usage: resize-image-width <filename> <width in pixels>"
	else
		convert -resize $2 $1 $1
  fi
}

# Trim video to time parameters.
function trim-video() {
	if [ $# -ne 3 ]; then
	  echo "Ops. Please enter the start time and duration for the video in seconds."
	  echo "Usage: trim-video <input_movie.mov> <time in seconds from start> <duration of new clip>"
	  echo 'Example: "trim-video myvideo.mov 3 10" Produces and 10 second video begining from 3 seconds inside the original clip.' 
	else
		echo "Begining to trim video length..."
		ffmpeg -i $1 -ss $2 -c copy -t $3 trimmed_$1
		echo "Complete."
  fi
}

# Turn that video into webm!
function webmify() {
	if [ $# -eq 0 ]; then
		echo "Oops. Please enter a filename. Usage: webmify <filename>"
	else
  	ffmpeg -i "$1" -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y "$1.webm"
  	google-chrome "$1.webm"
	fi
}

# Make an animated gif from any video file.
# gist.github.com/SlexAxton/4989674
# Requires gifsicle. sudo apt-get install gifsicle
function gifify() {
  if [[ -n "$1" ]]; then
	  if [[ $2 == '--better' ]]; then
	  	# gifsicle --optimize=3; Can be 1, 2, or 3. 3 is most aggressive.
	    ffmpeg -i "$1" -pix_fmt rgb24 -r 24 -f gif -vf scale=500:-1 - | gifsicle --optimize=2 > "$1.gif"
    elif [[ $2 == '--best' ]]; then
    	ffmpeg -i "$1" -pix_fmt rgb24 -f gif -vf scale=700:-1 - | gifsicle > "$1.gif"
	  else
	    ffmpeg -i "$1" -pix_fmt rgb24 -r 10 -f gif -vf scale=400:-1 - | gifsicle --optimize=3 --delay=3 > "$1.gif"
	  fi
	  google-chrome "$1.gif"
	else
		echo "Ops. Please enter a filename. Usage: gifify <input_movie.mov> [ --better | --best ]"
  fi
}

# ------------------------------------------------------------------------------
# | Aliases
# ------------------------------------------------------------------------------

# Change directory to your dotfiles directory.
alias dot="cd ~/.dotfiles"
# Change directory to the Desktop.
alias desk="cd ~/Desktop"
# Quickly switch to Sublime's config directory.
alias sublimedir="cd ~/.config/sublime-text-3/Packages/User"
# Dropbox directory. : )
alias d="cd ~/Dropbox"
# Sites folder.
alias s="cd ~/Dropbox/Sites"
# For when you make the typ-o that you *will* make.
alias cd..="cd .."
alias ...="cd ../../../" 

# List files in detail.
alias l="ls -laF"

# Shutdown.
alias done="sudo shutdown now"

# Update Ubuntu.
alias updateubuntu="sudo apt-get update -y && sudo apt-get autoclean -y && sudo apt-get clean -y && sudo apt-get upgrade -y && sudo apt-get autoremove --purge -y"

# Quickly clear the Terminal window.
alias c="clear"
# Minimal output at the command prompt.
alias minterm="export PS1=\"\$ \""
# Show diskspace usage on main volume.
alias diskspace="df -h | grep /dev/sda1"

# Open Apache's main config file.
alias configapache="sudo subl /etc/apache2/apache2.conf"
# Restart Apache.
alias restartapache="sudo service apache2 restart"
# Edit hosts file quickly.
alias hosts="sudo nano /etc/hosts"

# Pretty print Git's history.
alias gitlog="git log --graph --oneline --all --decorate"

# Open an emoji cheat sheet!
alias emojis="xdg-open http://www.emoji-cheat-sheet.com/"

# Copy a shuggie guy to the clipboard.
alias shruggie='printf "¯\_(ツ)_/¯" | xclip -selection c && echo "¯\_(ツ)_/¯ copied to clipboard."'

# Download YouTubes as mp3
alias yt-getaudio="yt-getaudio"

# Prep high-res images for upload to log.jonathanbell.ca
alias blogimages='echo "Converting images to lo-res..." && mkdir loRes > /dev/null 2>&1 && mogrify -resize 900 -quality 79 -path ./loRes *.jpg && echo "Done!"'
# Quick command to shrink an image by 50%. Useful for uploads to the web and such.
alias shrink-image="shrink-image"

# ------------------------------------------------------------------------------
# | Git
# ------------------------------------------------------------------------------

# Don't prompt for merge_msg in Git.
export GIT_MERGE_AUTOEDIT=no

# ------------------------------------------------------------------------------
# | Heroku
# ------------------------------------------------------------------------------

export PATH="/usr/local/heroku/bin:$PATH"

# ------------------------------------------------------------------------------
# | Colorize Things
# ------------------------------------------------------------------------------

# Colorize git branch and current directory.
export PS1="\[$(tput bold)\]\[\033[46m\]\W\[$(tput bold)\]\[\033[101m\]\$(parse_git_branch)\[\033[00m\] $ "

# Colorize 'grep'.
alias grep='grep --color=auto'

# Colors to differentiate different file types with 'ls'.
alias ls="command ls --color"
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"

# ------------------------------------------------------------------------------
# | Misc
# ------------------------------------------------------------------------------

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards.
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Autocorrect typos in path names when using 'cd'.
shopt -s cdspell;

# Omit duplicates from bash history and commands that begin with a space.
export HISTCONTROL='ignoreboth';

# Append to the Bash history file, rather than overwriting it.
shopt -s histappend;

# Make sublime text the default editor.
export EDITOR='subl';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob;

# If we have Bash open, we are probably coding. Set a deeper screen contrast.
xgamma -q -gamma 0.90

# Show Dropbox status.
echo "Dropbox Status:"
echo "==============="  
dropbox status
echo

# List aliases on Bash start.
echo "Aliases:"
echo "========"
alias | awk -F'=' '{print $1}' | grep "alias"
echo

# Check if Linux/Ubuntu.
if ! [ "$OSTYPE" = "linux-gnu" ]; then
  echo "*ALERT: Your .bashrc was loaded on a non-Ubunut/Linux system. Some things may not work well."
  echo # new line
fi # end if Ubuntu/Mac