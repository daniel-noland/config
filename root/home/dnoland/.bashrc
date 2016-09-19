# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source ~/.shellrc
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make ${PAGER} more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac


#Set the default editor... die nano die die die.
export EDITOR=vim #an editor for grown ups.
export PAGER=vimpager
#tmux ftw
export MULTIPLEXER="tmux -u"

#Source my aliases
if [ -f ~/.aliasrc ]; then
    source ~/.aliasrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# add local bin file to path
export PATH=$PATH:~/.bin
# add cuda tools to the path:
export PATH=$PATH:/usr/local/cuda/bin
# add cuda library to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# add remote mike shortcut
export mike=server-mike.dyndns-ip.com

# change the prompt in git repos to reflect the checked out branch
source ~/.bash/git-prompt.bash

# Non color version
#PS1="\u@\h:\w\$(parse_git_branch_or_tag) \n$ " 
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\] \$(parse_git_branch_or_tag)\[\033[00m\]\n$ "

#GPG
#if [ -f "${HOME}/.gpg-agent-info" ]; then
#   source "${HOME}/.gpg-agent-info" > /dev/null
#   export GPG_AGENT_INFO
#   export SSH_AUTH_SOCK
#fi
#GPG_TTY=$(tty)
#export GPG_TTY
# change the prompt in git repos to reflect the checked out branch
source ~/.bash/git-prompt.bash

#Fancy prompt
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\] \$(parse_git_branch_or_tag)\[\033[00m\]\n$ "

#Super fancy powerline prompt
#powerline
source /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

SHOPT=$(which shopt)
if [ -z $SHOPT ]; then
    shopt -s histappend        # Append history instead of overwriting
    shopt -s cdspell           # Correct minor spelling errors in cd command
    shopt -s dotglob           # includes dotfiles in pathname expansion
    shopt -s checkwinsize      # If window size changes, redraw contents
    shopt -s cmdhist           # Multiline commands are a single command in history.
    shopt -s extglob           # Allows basic regexps in bash.
fi
# auto start x on tty1 of navi
[[ -z $DISPLAY && $XDG_VTNR -eq 1 && $HOSTNAME -eq navi ]] && startx
