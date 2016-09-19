#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;

while (my $data = <>) {
    my @matches = $data =~ /(((https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6}))([\/\w \.-]*)*\/?)/g;
    if (scalar(@matches)) {
        print join("\n", @matches);
    }
}
