#!/usr/bin/env perl
use warnings;
use strict;
use IO::Capture::Stderr;
use Test::More tests => 1;
my $stderr = IO::Capture::Stderr->new;
$stderr->start;
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
$stderr->stop;
chomp(my @stderr = $stderr->read);
like(
    $stderr[0],
qr/String found where operator expected at \(eval \d+\) line \d+, near "say 'bar'"/,
    'stderr'
);
