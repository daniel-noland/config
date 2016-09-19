#!/usr/bin/env perl
perl -ne 'while(/(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/g){print \"$&\n\";}' /tmp/tmux-buffer | dmesg


