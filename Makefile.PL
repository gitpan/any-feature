
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'any::feature',
                       'DISTNAME' => 'any-feature',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'Backwards-compatible handling of new syntactic features',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100840',
                       'PREREQ_PM' => {
                                        'Scalar::Util' => '0',
                                        'Capture::Tiny' => '0',
                                        'English' => '0',
                                        'Carp' => '0',
                                        'Test::More' => '0.88',
                                        'File::Find' => '0',
                                        'File::Temp' => '0',
                                        'Perl::Version' => '0',
                                        'UNIVERSAL::require' => '0',
                                        'mysubs' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



