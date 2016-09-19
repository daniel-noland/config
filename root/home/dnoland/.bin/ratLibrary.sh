#!/usr/bin/env zsh

# Author: Daniel Noland
# Date: 2013-07-25
# This is a simple helper script which lets me find the ratpoison "implementation"
# of work spaces to be tolerable.

# Convenience functions
# =====================

# compute the total number of groups
function totalGroups() {
   echo -e $(ratpoison -c "groups" | wc -l)
}

# return current group number
function getCurrentGroupNumber() {
   echo -e $(ratpoison -c "groups" | sed -e "/\*[0-9]*/!d" -e "s/\*.*//")
}

# return current window number
function getCurrentWindowNumber() {
   echo -e $(ratpoison -c "windows" | sed -e "/[0-9]*\*/!d" -e "s/\([0-9]*\)\*.*/\1/")
}

# return current group name
function getCurrentGroupName() {
   echo -e $(ratpoison -c "groups" | sed -e "/[0-9]*\*/!d" -e "s/[0-9]*\*//")
}

# return current window name
function getCurrentWindowName() {
   echo -e $(ratpoison -c "windows" | sed -e "/[0-9]*\*/!d" -e "s/[0-9]*\*\(.*\)/\1/")
}

# get next group number
function getNextGroupNumber() {
   local group=$(( $(getCurrentGroupNumber) + 1 ))
   local group=$(( $group % $(totalGroups) ))
   echo $group
}

# get previous group number
function getPreviousGroupNumber() {
   local group=$(( $(getCurrentGroupNumber) - 1 ))
   [ $group -lt 0 ] && group=$(( $(totalGroups) - 1 ))
   echo $group
}

# change to group number (provided by first argument),
# update the screen to display a window specific to that group,
# and print the current group scan
function changeToGroupNumber() {
   #move to that group
   ratpoison -c "gselect $1"
   ratpoison -c "select -"
   ratpoison -c "next"
   scanAllGroups
}

# "Public Facing" Functions
# =========================

# return a formatted list of all the windows in all the groups
# with marks to indicate the active window and group
function scanAllGroups() {
   local initialGroup=$(getCurrentGroupNumber)
   local output=""
   for (( i=0; i<$(totalGroups); i++ ))
   do
      local mark="---"
      [ $i -eq $initialGroup ] && mark="***"
      ratpoison -c "gselect $i"
      name=$(getCurrentGroupName)
      output+=$mark$name$mark'\n'$(ratpoison -c "windows")'\n'
   done
   ratpoison -c "gselect $initialGroup"
   ratpoison -c "echo $(echo -e ${output})"
}

# Send the current window to the next group
function sendWindowToNextGroup() {
   ratpoison -c "gmove $(getNextGroupNumber)"
   ratpoison -c "next"
   scanAllGroups
}

# Send the current window to the previous group
function sendWindowToPreviousGroup() {
   ratpoison -c "gmove $(getNextPreviousNumber)"
   ratpoison -c "next"
   scanAllGroups
}

# Send the current window to the next group and switch to the next group
function followWindowToNextGroup() {
   ratpoison -c "gmove $(getNextGroupNumber)"
   changeToGroupNumber $(getNextGroupNumber)
   scanAllGroups
}

# Send the current window to the previous group and switch to the next group
function followWindowToPreviousGroup() {
   ratpoison -c "gmove $(getPreviousGroupNumber)"
   changeToGroupNumber $(getPreviousGroupNumber)
   scanAllGroups
}

# swap the active window on this monitor with screen on the next
#function swapScreens() {
#   local currentWindow=$(getCurrentWindowNumber)
#   ratpoison -c "select -"
#   ratpoison -c "nextscreen"
#   local otherWindow=$(getCurrentWindowNumber)
#   # this is not optional if you want it to correctly swap to blank
#   # windows.
#   ratpoison -c "select -"
#   ratpoison -c "select $currentWindow"
#   ratpoison -c "prevscreen"
#   ratpoison -c "select $otherWindow"
#}

# swap the active window on this monitor with screen on the next
function swapScreens() {
   local firstScreenNumber=$(ratpoison -c info | sed -e 's/.*\([0-9]\)(.*/\.*1/')
   local firstFDump=$(ratpoison -c "fdump")
   ratpoison -c "select -"
   ratpoison -c "nextscreen"
   local secondScreenNumber=$(ratpoison -c info | sed -e 's/.*\([0-9]\)(.*/\.*1/')
   local secondFDump=$(ratpoison -c "fdump")
   ratpoison -c "select -"
   ratpoison -c "frestore $firstFDump"
   ratpoison -c "prevscreen"
   ratpoison -c "frestore $secondFDump"
}
