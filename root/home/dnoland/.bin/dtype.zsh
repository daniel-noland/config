_dmenu() {
   dmenu -fn 'Droid Sans Mono-20' -l 4 $*
}

mrused() {
   echo "$(fasd -l -a ${1} | _dmenu)"
}

target="$(mrused ${1})"
xdotool type --delay 0 "${target}"
