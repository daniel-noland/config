#! /bin/bash

# if no session is started, start a new session

tmux -u -2 attach -t secondary \
   || \
tmux \
   -u -2 \
   new -s secondary
