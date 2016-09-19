#!/usr/bin/zsh

# if no session is started, start a new session
tmux -u -2 attach -t primary \
   || \
tmux \
   -u -2 \
   new -s primary

