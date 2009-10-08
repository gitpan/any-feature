use inc::Module::Install;
include 'Module::AutoInstall';
name 'any-feature';
all_from 'lib/any/feature.pm';
readme_from 'lib/any/feature.pm';
readme_markdown_from 'lib/any/feature.pm';
auto_set_homepage;
auto_set_bugtracker;
auto_set_repository;
requires 'Perl::Version';
requires 'UNIVERSAL::require';

if ($] =~ /^5\.008/) {
    requires 'Perl6::Say';
    requires 'mysubs';
}
test_requires 'Test::More' => '0.70';
test_requires 'Capture::Tiny';
extra_tests;
author_requires 'ShipIt';
author_requires 'ShipIt::Step::DistClean';
author_requires 'ShipIt::Step::DistTestExtra';
author_requires 'ShipIt::Step::Manifest';
author_requires 'ShipIt::Step::Twitter';
author_requires 'Test::Compile';
author_requires 'Test::Perl::Critic';
author_requires 'Test::Pod';
author_requires 'Test::Spelling';
author_requires 'Pod::Wordlist::hanekomu';
author_requires 'Test::Pod::Coverage';

# author_requires 'Test::Kwalitee';   # Attempt to free unreferenced scalar
author_requires 'Test::YAML::Meta';
author_requires 'Test::Portability::Files';
author_requires 'Test::Synopsis';
auto_install;
auto_include;
WriteAll;