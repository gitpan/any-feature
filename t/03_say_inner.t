#!/usr/bin/env perl
use strict;
use warnings;
use Capture::Tiny qw(capture);
use Test::More tests => 3;
sub say { 'outer' }

# make sure the inner lexical doesn't clobber the outer sub after its scope
# ends
sub test_clobber() {
    is say(), 'outer', 'pre: outer sub';
    my ($stdout, $stderr) = capture {
        use any::feature qw(say);
        say 'inner';
    };
    is $stdout, "inner$/", 'shadowed sub';
    is say(), 'outer', 'post: outer sub';
}
test_clobber();
