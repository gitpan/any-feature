#!/usr/bin/env perl
use warnings;
use strict;
use Capture::Tiny qw(capture);
use Test::More tests => 1;
my ($stdout, $stderr) = capture {
    eval <<EOCODE;
    {
        use any::feature 'say';
        say 'foo 1';
        no any::feature 'say';
        use any::feature 'say';
        say 'foo 2';
        no any::feature 'say';
    }
    say 'bar';
EOCODE
};
like(
    $stderr,
qr/String found where operator expected at \(eval \d+\) line \d+, near "say 'bar'"/,
    'stderr'
);
