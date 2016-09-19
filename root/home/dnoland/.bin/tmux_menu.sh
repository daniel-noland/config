#!/usr/bin/env zsh
# -*- encoding UTF-8 -*-
# Author: Daniel Noland
# Purpose: use dmenu to switch between tmux windows

# Usage: bind this script to a key in your WM and you can use auto complete to
# jump between window in the most recently active tmux session.

list_windows() {
   tmux list-windows | cut -d" " -f1-2
}

get_leading_number() {
   local description="$1"
   echo ${description} | sed -r 's/^([0-9]*):.*/\1/'
}

pick_window() {
   local target="$1"
   tmux select-window -t "${target}"
}

local selection_name=$(list_windows | dmenu -l 5 -fn 'Droid Sans Mono-30')
local selection_number=$(get_leading_number ${selection_name})
pick_window ${selection_number}
