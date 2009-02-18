use inc::Module::Install;
include 'Module::AutoInstall';

name 'any-feature';
all_from 'lib/any/feature.pm';
perl_version '5.008';

requires 'Perl::Version';

unless ($] =~ /^5\.010/) {
    requires 'UNIVERSAL::require';
    requires 'Sub::Delete';
    requires 'Perl6::Say';
}

test_requires 'Test::More' => '0.70';
test_requires 'IO::Capture::Stdout';
test_requires 'IO::Capture::Stderr';

extra_tests;

auto_install;
auto_include;
WriteAll;
