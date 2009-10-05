#!/usr/bin/env perl
use warnings;
use strict;
use IO::Capture::Stdout;
use IO::Capture::Stderr;
use Test::More tests => 2;
my $stdout = IO::Capture::Stdout->new;
my $stderr = IO::Capture::Stderr->new;
$stdout->start;
$stderr->start;
use any::feature 'say';
say 'Hello, world!';
$stdout->stop;
$stderr->stop;
chomp(my @stdout = $stdout->read);
chomp(my @stderr = $stderr->read);
is_deeply(\@stdout, ['Hello, world!'], 'stdout');
is_deeply(\@stderr, [], 'stderr');
