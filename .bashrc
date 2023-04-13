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

# turn on fzf autocomplete if available
if [ -f  "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
   source /usr/share/doc/fzf/examples/key-bindings.bash
fi

export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCREEN_SCALE_FACTORS=2

if [ -f  "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Custom prompt generation
# Don't show username on prompt if it's in this list
HIDE_ALIASES="10141585 keegan kowsley "

# Handy dandy color aliases
# Reset
COLOR_OFF='\e[0m'       # Text Reset

# Regular Colors
BLACK='\e[0;30m'        # Black
RED='\e[0;31m'          # Red
GREEN='\e[0;32m'        # Green
YELLOW='\e[0;33m'       # Yellow
BLUE='\e[0;34m'         # Blue
PURPLE='\e[0;35m'       # Purple
CYAN='\e[0;36m'         # Cyan
WHITE='\e[0;37m'        # White

# Bold
BBLACK='\e[1;30m'       # Black
BRED='\e[1;31m'         # Red
BGREEN='\e[1;32m'       # Green
BYELLOW='\e[1;33m'      # Yellow
BBLUE='\e[1;34m'        # Blue
BPURPLE='\e[1;35m'      # Purple
BCYAN='\e[1;36m'        # Cyan
BWHITE='\e[1;37m'       # White

# Underline
UBLACK='\e[4;30m'       # Black
URED='\e[4;31m'         # Red
UGREEN='\e[4;32m'       # Green
UYELLOW='\e[4;33m'      # Yellow
UBLUE='\e[4;34m'        # Blue
UPURPLE='\e[4;35m'      # Purple
UCYAN='\e[4;36m'        # Cyan
UWHITE='\e[4;37m'       # White

# Background
ON_BLACK='\e[40m'       # Black
ON_RED='\e[41m'         # Red
ON_GREEN='\e[42m'       # Green
ON_YELLOW='\e[43m'      # Yellow
ON_BLUE='\e[44m'        # Blue
ON_PURPLE='\e[45m'      # Purple
ON_CYAN='\e[46m'        # Cyan
ON_WHITE='\e[47m'       # White

# High Intensity
IBLACK='\e[0;90m'       # Black
IRED='\e[0;91m'         # Red
IGREEN='\e[0;92m'       # Green
IYELLOW='\e[0;93m'      # Yellow
IBLUE='\e[0;94m'        # Blue
IPURPLE='\e[0;95m'      # Purple
ICYAN='\e[0;96m'        # Cyan
IWHITE='\e[0;97m'       # White

# Bold High Intensity
BIBLACK='\e[1;90m'      # Black
BIRED='\e[1;91m'        # Red
BIGREEN='\e[1;92m'      # Green
BIYELLOW='\e[1;93m'     # Yellow
BIBLUE='\e[1;94m'       # Blue
BIPURPLE='\e[1;95m'     # Purple
BICYAN='\e[1;96m'       # Cyan
BIWHITE='\e[1;97m'      # White

# High Intensity backgrounds
ON_IBLACK='\e[0;100m'   # Black
ON_IRED='\e[0;101m'     # Red
ON_IGREEN='\e[0;102m'   # Green
ON_IYELLOW='\e[0;103m'  # Yellow
ON_IBLUE='\e[0;104m'    # Blue
ON_IPURPLE='\e[0;105m'  # Purple
ON_ICYAN='\e[0;106m'    # Cyan
ON_IWHITE='\e[0;107m' # White

USERCOLOR="${BGREEN}"
HOSTCOLOR="${WHITE}"

# Handy function for determining if something is part of a space-delimited list
function contains {
    [[ $1 =~ (^|[[:space:]])"$2"($|[[:space:]]) ]] && echo 'yes' || echo 'no' 
}

function __setprompt
{
    local LAST_COMMAND=$? # Must come first!

    # Show error exit code if there is one
    if [[ $LAST_COMMAND != 0 && $LAST_COMMAND != 148 ]]; then
        # PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
        PS1="\[${COLOR_OFF}\](\[${BRED}\]ERROR\[${COLOR_OFF}\])-(\[${Red}\]Exit Code \[${BRED}\]${LAST_COMMAND}\[${COLOR_OFF}\])-(\[${Red}\]"
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
            # I already know I hit Ctrl+C, don't add it to my prompt
            # PS1+="Script terminated by Control-C" 
            :
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
        PS1+="\[${COLOR_OFF}\])\[${COLOR_OFF}\]\n"
    else
        PS1=""
    fi
    JOBS="$(jobs -p)"

    PS1+='${JOBS:+'"\[${RED}\][\[${BWHITE}\]\j\[${RED}\]] }"

    # User and server
    local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
    local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
    if [ $SSH2_IP ] || [ $SSH_IP ] ; then
        PS1="$PS1""\[${PURPLE}\](ssh: "
        # Only show username if unusual
        if [ ! `contains "$HIDE_ALIASES" "$USERNAME"` == yes ]; then
            if [ "$USERNAME" = root ]; then
                PS1="$PS1""\[${BRED}\]\u\[${CYAN}\]@"
            else
                PS1="$PS1""\[${USERCOLOR}\]\u\[${CYAN}\]@"
            fi
            PS1="$PS1""\[${HOSTCOLOR}\]\h\[${PURPLE}\]) " # Add indicator if we're on ssh
            fi
        else # Attached locally
            if [ ! `contains "$HIDE_ALIASES" "$USER"` == yes ]; then
                # Display non-standard user
                if [ "$USER" = root ]; then
                    PS1="$PS1\[${BRED}\]\u "
                else
                    PS1="$PS1\[${USERCOLOR}\]\u "
                fi
            fi
        fi


        function parse_git_dirty {
            [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
        }
        function parse_git_branch {
            git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
        }
        GIT_BRANCH="`parse_git_branch`"

        PS1="$PS1\[${CYAN}\]\w\[${RED}\]"'${GIT_BRANCH}'"\[${COLOR_OFF}\]"

        if [[ $EUID -ne 0 ]]; then
            PS1+=' $ ' # Normal user
        else
            PS1+="\[${RED}\]\#\[${COLOR_OFF}\] " # Root user
        fi

# PS2 is used to continue a command using the \ character
PS2="\[${COLOR_OFF}\]>\[${COLOR_OFF}\] "

# PS3 is used to enter a number choice in a script
PS3='Please enter a number from above list: '

# PS4 is used for tracing a script in debug mode
PS4='\[${COLOR_OFF}\]+\[${COLOR_OFF}\] '

}
PROMPT_COMMAND='__setprompt'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
