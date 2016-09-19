#!/usr/bin/zsh
source ~/ratLibrary.sh
loading=true
timeout=50

ratpoison -c "set padding 26 0 0 0"
trayer --edge left &
ratpoison -c "unmanage panel"
thunderbird &
google-chrome-beta &
roxterm -e ~/.bin/tmuxPrimary.sh &
pidgin &

typeset -A titleList
titleList=(\
   roxterm primary\
   Google-chrome-beta browser\
   Mail email\
   Pidgin chat\
)

typeset -A destList
destList=(\
   primary 0,0\
   browser 0,1\
   email 1,0\
   chat  1,1\
)

initialScreen=0
totalScreens=2
initialWorkspace=0

totalWorkspaces=2
screen=$initialScreen
workspace=$initialWorkspace

function nextscreen() {
   screen=$(( ($screen + 1) % $totalScreens ))
   ratpoison -c nextscreen
   echo $screen
}

function gotoScreen() {
   for i in {1..$totalScreens}; do
      screen=$(nextscreen)
      [ $screen = "$1" ] && echo "screen=$1" && return 0
   done
   return 1
}

function nextWorkspace() {
   workspace=$(( ($workspace + 1) % $totalWorkspaces ))
   ratSpaces.sh inc
   echo $workspace
}

function gotoWorkspace() {
   for i in {1..$totalWorkspaces}; do
      screen=$(nextscreen)
      [ $screen = "$1" ] && echo "screen=$1" && return 0
   done
   return 1
}

function setTitle() {
   ratpoison -c "select $1"
   sleep 0.05
   ratpoison -c "title $2"
}

function getWindowNumber() {
   windows=$(ratpoison -c "windows %n %a")
   echo $windows | grep -i "$1" | awk '{print $1}' | head -n 1
}

function setNames() {
   timeoutReached=false
   for name in ${(k)titleList}; do
      i=0
      while [ $i -le $timeout ]; do
         winNumber=$(getWindowNumber $name)
         if [[ $(getWindowNumber "$name") == <-> ]]; then
            setTitle $winNumber ${titleList[$name]}
            break
         fi
         i=$(( $i + 1 ))
         sleep 0.1
      done
      if [ $i -eq $timeout ]; then
         echo "timeout reached"
         timeoutReached=true
      fi
   done
   [ $timeoutReached = false ] && return 0 || return 1
}

function moveCurrentWindow() {
   targetWorkspace=$(echo "$1" | sed -r -e 's/^([0-9]{1,})\,.*/\1/')
   targetScreen=$(echo "$1" | sed -r -e 's/.*\,([0-9]{1,})/\1/')
   currentWindowNumber=$(getCurrentWindowNumber)
   echo $targetWorkspace
   echo $targetScreen
   echo $currentWindowNumber
   echo hello
   if [[ $(getCurrentGroupNumber) != $targetWorkspace ]]; then
      ratpoison -c "gmove $targetWorkspace"
      sleep 0.05
      ratpoison -c "select $currentWindowNumber"
   fi
   if [[ $screen != $targetScreen ]]; then
      ratpoison -c "select -"
      gotoScreen $targetScreen
      ratpoison -c "select $currentWindowNumber"
   fi
}

function gotoInitialConfiguartion() {
   ratpoison -c "gselect 0"
   gotoScreen 0
   ratpoison -c "select -"
}

function assignWorkspaces() {
   for title in ${(k)destList}; do
      win="$title"
      dest="${destList[$title]}"
      ratpoison -c "select $title"
      moveCurrentWindow "$dest"
      sleep 0.15
      gotoInitialConfiguartion
   done
   changeToGroupNumber 0
   gotoScreen 0
}

setNames
assignWorkspaces
gotoScreen 1
ratpoison -c "select 0"
#ratpoison -c "set padding 26 0 0 0"
