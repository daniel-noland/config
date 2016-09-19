#!/bin/zsh
debugfile=$HOME/xinitdebug
logging=false
function log() {
   if [ $logging == true ]; then
      echo "$1" >> $debugfile
   fi
}
log ".xinitrc started"
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

mkdir -p ${HOME}/ram/bin
function tmpload() {
   if [ -x /tmp/"$1" ]; then
      log "$1 already tmploaded"
   else
      sudo cp $(whence -p "$1") ~/ram/bin
      #sudo cp $(which -p "$1") ~/ram/bin
   fi
}

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap" && log "$usermodmap loaded" 
fi

if test -f $XDG_RUNTIME_DIR/gpg-agent-info && kill -0 $(head -n 1 $XDG_RUNTIME_DIR/gpg-agent-info | cut -d: -f2) 2>/dev/null ; then
    eval $(< $XDG_RUNTIME_DIR/gpg-agent-info)
else
    eval $(gpg-agent --daemon --enable-ssh-support --write-env-file $XDG_RUNTIME_DIR/gpg-agent-info)
fi
export GPG_AGENT_INFO
export SSH_AUTH_SOCK

setxkbmap -option ctrl:nocaps && log "setxkbmap called"
powerline-daemon
start xscreensaver
( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )
xautolock -time 100 -locker "systemctl suspend" -detectsleep &
xss-lock -- xscreensaver-command -lock &
exec i3
# exec startxfce4
# exec ratpoison
# exec startfluxbox
# exec awesome
# log ".xinitrc finished"
