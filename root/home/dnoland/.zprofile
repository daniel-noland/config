[[ -z $DISPLAY && $(echo $TTY | sed 's/.*\([0-9]\)$/\1/') -eq 1 ]] && startx
