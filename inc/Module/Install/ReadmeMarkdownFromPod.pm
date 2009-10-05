#line 1
package Module::Install::ReadmeMarkdownFromPod;

use 5.006;
use strict;
use warnings;
use Pod::Markdown;

our $VERSION = '0.01';

use base qw(Module::Install::Base);

sub readme_markdown_from {
    my $self = shift;
    return unless $Module::Install::AUTHOR;
    my $file = shift || return;
    my $clean = shift;

    my $parser = Pod::Markdown->new;
    $parser->parse_from_file($file);
    open my $fh, '>', 'README.mkdn' or die "$!\n";
    print $fh $parser->as_markdown;
    close $fh or die "$!\n";

    return 1 unless $clean;
    $self->postamble(<<"END");
distclean :: license_clean

license_clean:
\t\$(RM_F) README.mkdn
END
    1;
}

1;

__END__

#line 122
