#!/usr/bin/zsh
devInfo=$(ip -4 address show dev "$1")
ipExitCode=$?
[ "${ipExitCode}" != 0 ] && echo "<<<NO IP FOUND>>>" && exit 1;
echo "$devInfo" | grep "inet " | col -x | sed -r -e 's/[^0-9./ ]//g' -e 's/^ *//g' -e 's/ {1,}/ /' | cut -d " " -f 1 | sed -r -e 's|(.*)/.*|\1|'
