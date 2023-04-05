# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Disable the bell
if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH=$PATH:/home/keegan/.local/bin

# Are we Debian?
if [ -f "/etc/debian_version" ]; then
	DEBIAN=y
fi

function install_nvim () {
	if [ -n "$DEBIAN" ]; then
		curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb --output nvim-linux64.deb
		sudo apt install ./nvim-linux64.deb
	else
		mkdir -p "$HOME/.local/bin"
		curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage --output "$HOME/.local/bin/nvim"
		chmod +x "$HOME/.local/bin/nvim"
	fi
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

function import_host_certs_wsl () {
    powershell.exe -c - << 'EOF'
$certificateType = [System.Security.Cryptography.X509Certificates.X509Certificate2]

$includedStores = @("TrustedPublisher", "Root", "CA", "AuthRoot")

$certificates = $includedStores.ForEach({
    Get-ChildItem Cert:\CurrentUser\$_ | Where-Object { $_ -is $certificateType}
})

$pemCertificates = $certificates.ForEach({
    $pemCertificateContent = [System.Convert]::ToBase64String($_.RawData,1)
    "-----BEGIN CERTIFICATE-----`n${pemCertificateContent}`n-----END CERTIFICATE-----"
})

$uniquePemCertificates = $pemCertificates | select -Unique

($uniquePemCertificates | Out-String).Replace("`r", "") | Out-File -Encoding UTF8 win-ca-certificates.crt
EOF
    NUM_CERTS=$(grep "BEGIN CERTIFICATE" win-ca-certificates.crt | wc -l)
    echo "Importing $NUM_CERTS certificates from host..."
    # chomp trailing newline
    # perl -pi -e 'chomp if eof' win-ca-certificates.crt
    sudo mv win-ca-certificates.crt /usr/local/share/ca-certificates/
	sudo update-ca-certificates -f
}

function install_handy_packages () {
    sudo apt install ripgrep fd-find fzf build-essential git bat
}

# Broken, don't use
function import_host_certs_wsl_broken () {
	# Use powershell to export host certs matching the first argument
	if [ $# -eq 0 ]
	then
		echo "Supply a matching string as argument (eg, 'BD' to match all certs with BD in the name)"
		return
	fi
		
	TMPDIR="$(mktemp -d)"
	pushd "$TMPDIR"
	powershell.exe -c '$i=0; foreach($cert in @(Get-ChildItem "Cert:\CurrentUser\$_" -recurse | Where-Object { $_.Subject -match "CN='"$1"'" })) { Export-Certificate -Cert $cert -FilePath host-cert$i.cer -Type CERT; $i++ }'
	for cert in host-cert*.cer
	do
		newname=${cert%cer}crt
		openssl x509 -inform der -in "$cert" -out "$newname"
		sudo mv "$newname" /usr/local/share/ca-certificates/
		rm "$cert"
	done
	sudo update-ca-certificates -f
	popd

}

# turn on fzf autocomplete if available
if [ -f  "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
   source /usr/share/doc/fzf/examples/key-bindings.bash
fi

export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCREEN_SCALE_FACTORS=2

alias dgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'

if [ -f  "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if command -v nvim &> /dev/null
then
    alias vim=nvim
    alias vi=nvim
fi

if command -v fzf &> /dev/null
then
    function p
    {
        # fuzzy find projects
        # TODO: customizable readme locations
        # TODO: source project-specific dotfiles
        PROJECTS=$(<$HOME/.projects)
        #SELECTED_PROJECT=$(echo "$PROJECTS" | fzf --query="$1" -1 --preview "batcat --color=always --style=numbers {}/README.md")
        SELECTED_PROJECT=$(echo "$PROJECTS" | fzf --query="$1" -1 --preview "ls -lAF {}")
        cd $SELECTED_PROJECT
    }
fi


alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias bd='cd "$OLDPWD"'


function __setprompt
{
	local LAST_COMMAND=$? # Must come first!

	# Define colors
	local LIGHTGRAY="\033[0;37m"
	local WHITE="\033[1;37m"
	local BLACK="\033[0;30m"
	local DARKGRAY="\033[1;30m"
	local RED="\033[0;31m"
	local LIGHTRED="\033[1;31m"
	local GREEN="\033[0;32m"
	local LIGHTGREEN="\033[1;32m"
	local BROWN="\033[0;33m"
	local YELLOW="\033[1;33m"
	local BLUE="\033[0;34m"
	local LIGHTBLUE="\033[1;34m"
	local MAGENTA="\033[0;35m"
	local LIGHTMAGENTA="\033[1;35m"
	local CYAN="\033[0;36m"
	local LIGHTCYAN="\033[1;36m"
    local BOLD="\033[1m"
	local NOCOLOR="\033[0m"

	# Show error exit code if there is one
    if [[ $LAST_COMMAND != 0 && $LAST_COMMAND != 148 ]]; then
		# PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
		PS1="\[${NOCOLOR}\](\[${LIGHTRED}\]ERROR\[${NOCOLOR}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${NOCOLOR}\])-(\[${RED}\]"
		if [[ $LAST_COMMAND == 1 ]]; then
			PS1+="General error"
		elif [ $LAST_COMMAND == 2 ]; then
			PS1+="Missing keyword, command, or permission problem"
		elif [ $LAST_COMMAND == 126 ]; then
			PS1+="Permission problem or command is not an executable"
		elif [ $LAST_COMMAND == 127 ]; then
			PS1+="Command not found"
		elif [ $LAST_COMMAND == 128 ]; then
			PS1+="Invalid argument to exit"
		elif [ $LAST_COMMAND == 129 ]; then
			PS1+="Fatal error signal 1"
		elif [ $LAST_COMMAND == 130 ]; then
			PS1+="Script terminated by Control-C"
		elif [ $LAST_COMMAND == 131 ]; then
			PS1+="Fatal error signal 3"
		elif [ $LAST_COMMAND == 132 ]; then
			PS1+="Fatal error signal 4"
		elif [ $LAST_COMMAND == 133 ]; then
			PS1+="Fatal error signal 5"
		elif [ $LAST_COMMAND == 134 ]; then
			PS1+="Fatal error signal 6"
		elif [ $LAST_COMMAND == 135 ]; then
			PS1+="Fatal error signal 7"
		elif [ $LAST_COMMAND == 136 ]; then
			PS1+="Fatal error signal 8"
		elif [ $LAST_COMMAND == 137 ]; then
			PS1+="Fatal error signal 9"
		elif [ $LAST_COMMAND -gt 255 ]; then
			PS1+="Exit status out of range"
		else
			PS1+="Unknown error code"
		fi
		PS1+="\[${NOCOLOR}\])\[${NOCOLOR}\]\n"
	else
		PS1=""
	fi

    JOBS=$(jobs | wc -l)
    if [ $JOBS -ne "0" ] ; then
        if [ $JOBS -eq "1" ] ; then

            PS1+="\[${NOCOLOR}\](\[${MAGENTA}\]\j"

            PS1+="\[${NOCOLOR}\] Job) "
        else
            PS1+="\[${NOCOLOR}\](\[${MAGENTA}\]\j"

            PS1+="\[${NOCOLOR}\] Jobs) "
        fi

    fi
	# User and server
	local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
	local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
	if [ $SSH2_IP ] || [ $SSH_IP ] ; then
		PS1+="\[${GREEN}${BOLD}\]\u@\h"
	else
		PS1+="\[${GREEN}${BOLD}\]\u"
	fi

	# Current directory
	PS1+="\[${NOCOLOR}\]:\[${BLUE}\]\w\[${NOCOLOR}\]"

    function parse_git_dirty {
        [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
    }
    function parse_git_branch {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
    }

    function install_fonts {
        # TODO: don't clone the whole repo, it's huge
        git clone https://github.com/ryanoasis/nerd-fonts.git "$HOME/.nerd_fonts"
        pushd "$HOME/.nerd_fonts"
        if command -v powershell.exe &> /dev/null
        then
            # We on Windows
            powershell.exe -c "./install.ps1 Meslo, JetBrainsMono"
        else
            bash ./install.sh Meslo, JetBrainsMono
        fi
    }

    # Git branch
    PS1+="\[${CYAN}\]$(parse_git_branch) "

	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${NOCOLOR}\]\$\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${RED}\]\$\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${NOCOLOR}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${NOCOLOR}\]+\[${NOCOLOR}\] '
}
PROMPT_COMMAND='__setprompt'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
