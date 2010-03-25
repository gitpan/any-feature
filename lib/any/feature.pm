use 5.008;
use strict;
use warnings;

package any::feature;
# ABSTRACT: Backwards-compatible handling of new syntactic features

use Perl::Version;
use Carp qw(croak);
use UNIVERSAL::require;

BEGIN {
    if ($] =~ /^5\.008/) {
        require mysubs;
    }
}
our $VERSION = '0.05';
my %dispatch = (
    activate => {
        say => {
            8 => sub {
                Perl6::Say->require or die $@;

                # no need to specify the target - mysubs uses
                # Devel::Pragma::ccstash, which does the right thing if this
                # module is subclassed
                mysubs->import(say => \&Perl6::Say::say);
            },
            10 => sub {
                feature->require or die $@;
                feature->import(qw(say));
            },
        },
    },
    deactivate => {
        say => {
            8 => sub {

                # no need to specify the target - mysubs uses
                # Devel::Pragma::ccstash, which does the right thing if this
                # module is subclassed
                mysubs->unimport('say');
            },
            10 => sub {
                feature->require or die $@;
                feature->unimport(qw(say));
            },
        },
    },
);

sub get_effective_revision {
    our $perl_version ||= Perl::Version->new($]);
    $perl_version->revision;
}

sub get_effective_version {
    our $perl_version ||= Perl::Version->new($]);
    my $version = $perl_version->version;

    # assume perl 5.11 and later behave the same as perl 5.10
    $version = 10 if $version > 10;
    $version;
}

sub dispatch {
    my ($direction, $target, $feature) = @_;
    my $code = $dispatch{$direction}{$feature}{ get_effective_version() };
    unless (ref $code eq 'CODE') {
        croak "unknown feature '$feature'\n";
    }
    $code->($target);
}

sub activate {
    my ($target, $feature) = @_;
    dispatch(activate => $target, $feature);
}

sub deactivate {
    my ($target, $feature) = @_;
    dispatch(deactivate => $target, $feature);
}

sub import {
    my $pkg    = shift;
    my $target = (caller());
    $Carp::CarpInternal{__PACKAGE__}++;
    unless (get_effective_revision() == 5) {
        croak "perl 5.* required\n";
    }
    for my $feature (@_) {
        activate($target, $feature);
    }
}

sub unimport {
    my $pkg    = shift;
    my $target = (caller());
    unless (get_effective_revision() == 5) {
        croak "perl 5.* required\n";
    }
    for my $feature (@_) {
        deactivate($target, $feature);
    }
}
1;


__END__
=pod

=head1 NAME

any::feature - Backwards-compatible handling of new syntactic features

=head1 VERSION

version 1.100840

=head1 SYNOPSIS

    use any::feature 'say';
    say 'Hello, world!';

=head1 DESCRIPTION

=head2 THE PROBLEM

Perl 5.10 introduces new syntactic features which you can activate and
deactivate with the C<feature> module. You want to use the C<say> feature in a
program that's supposed to run under both Perl 5.8 and 5.10. So your program
looks like this:

    use feature 'say';
    say 'Hello, world!';

But this only works in Perl 5.10, because there is no C<feature> module in
Perl 5.8. So you write

    use Perl6::Say;
    say 'Hello, world!';

This works, but it's strange to force Perl 5.10 users to install L<Perl6::Say>
when the C<say> feature is included in Perl 5.10.

=head2 THE SOLUTION

Use C<any::feature>!

WARNING: This is just a proof-of-concept.

C<any::feature> can be used like Perl 5.10's C<feature> and will try to "do
the right thing", regardless of whether you use Perl 5.8 or Perl 5.10.

At the moment, this is just a proof-of-concept and only handles the C<say>
feature. If things work out, I plan to extend it with other Perl 5.10
features.

The following programs should work and exhibit the same behaviour both in Perl
5.8 and Perl 5.10.

This program will work:

    use any::feature 'say';
    say 'Hello, world!';

This program will fail at compile-time:

    use any::feature 'say';
    say 'Hello, world!';

    no any::feature 'say';
    say 'Oops';

The features are lexically scoped, which is how they work in Perl 5.10:

    {
        use any::feature 'say';
        say 'foo';
    }
    say 'bar';     # dies at compile-time

=head1 FUNCTIONS

=head2 dispatch

Takes as arguments a direction (C<activate> or C<deactivate>), a package name
and a feature name. Activates or deactivates the given feature for the given
package.

=head2 activate

Takes as arguments a package name and a feature name. Uses C<dispatch()> to
activate the given feature in the given package.

=head2 deactivate

Takes as arguments a package name and a feature name. Uses C<dispatch()> to
deactivate the given feature in the given package.

=head2 import

Takes the same arguments as Perl 5.10's C<use feature> pragma. Uses
C<activate()> and C<deactivate()> to do its job.

=head2 unimport

Takes the same arguments as Perl 5.10's C<no feature> pragma. Uses
C<activate()> and C<deactivate()> to do its job.

=head2 get_effective_version

Uses L<Perl::Version> to get the version number of the current perl
interpreter.  This is used to decide the course of action.

=head2 get_effective_revision

Uses L<Perl::Version> to get the revision number of the current perl
interpreter.  This is used to decide the course of action.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=any-feature>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/any-feature/>.

The development version lives at
L<http://github.com/hanekomu/any-feature/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

