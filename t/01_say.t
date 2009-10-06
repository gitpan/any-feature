#!/usr/bin/env perl
use warnings;
use strict;
use Capture::Tiny qw(capture);
use Test::More tests => 2;
use any::feature 'say';

my ($stdout, $stderr) = capture {
    say 'Hello, world!';
};
is($stdout, "Hello, world!\n", 'stdout');
is($stderr, '', 'stderr');
