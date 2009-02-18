#line 1
package IO::Capture::Stderr;
use strict;
use warnings;
use Carp;
use base qw/IO::Capture/;
use IO::Capture::Tie_STDx;

sub _start {
	my $self = shift;
	$self->line_pointer(1);

	if ( _capture_warn_check() ) {
		$self->{'IO::Capture::handler_save'} = defined $SIG{__WARN__} ? $SIG{__WARN__} : 'DEFAULT';
		$SIG{__WARN__} = sub {print STDERR @_;};
	}
	else {
		$self->{'IO::Capture::handler_save'} = undef;
	}
    tie *STDERR, "IO::Capture::Tie_STDx";
}

sub _retrieve_captured_text {
    my $self = shift;
    my $messages = \@{$self->{'IO::Capture::messages'}};

     @$messages = <STDERR>;
	return 1;
}

sub _check_pre_conditions {
	my $self = shift;

	return unless $self->SUPER::_check_pre_conditions;

	if (tied *STDERR) {
		carp "WARNING: STDERR already tied, unable to capture";
		return;
	}
	return 1;
}

sub _stop {
	my $self = shift;
    untie *STDERR;
	$SIG{__WARN__} = $self->{'IO::Capture::handler_save'} if defined $self->{'IO::Capture::handler_save'};
    return 1;
}

#  _capture_warn_check
#
#  Check to see if SIG{__WARN__} handler should be set to direct output
# from warn() to IO::Capture::Stderr.  
#   There are three things to take into consideration.  
#   
#   1) Is the version of perl less than 5.8?
#      - Before 5.8, there was a bug that caused output from warn() 
#        not to be sent to STDERR if it (STDERR) was tied.
#        So, we need to put a handler in to send warn() text to
#        STDERR so IO::Capture::Stderr will capture it.
#   2) Is there a handler set already?
#      - The default handler for SIG{__WARN__} is to send to STDERR.
#        But, if it is set by the program, it may do otherwise, and
#        we don't want to break that. 
#   3)  FORCE_CAPTURE_WARN => 1
#      - To allow users to override a previous handler that was set on
#        SIG{__WARN__}, there is a variable that can be set.  If set,
#        when there is a handler set on IO::Capture::Stderr startup,
#        it will be saved and a new hander set that captures output to
#        IO::Capture::Stderr.  On stop, it will restore the programs
#        handler.
#      
#
#                    
#    Perl   |  FORCE_CAPTURE_WARN  |  Program has   | Set our own
#    < 5.8  |  is set              |  handler set   | handler
#   --------+----------------------+----------------+------------
#           |                      |                |
#   --------+----------------------+----------------+------------
#      X    |                      |                |     X (1)
#   --------+----------------------+----------------+------------
#           |          X           |                |
#   --------+----------------------+----------------+------------
#      X    |          X           |                |     X (1)
#   --------+----------------------+----------------+------------
#           |                      |        X       |
#   --------+----------------------+----------------+------------
#      X    |                      |        X       |
#   --------+----------------------+----------------+------------
#           |          X           |        X       |     X (2)
#   --------+----------------------+----------------+------------
#      X    |          X           |        X       |     X (2)
#   --------+----------------------+----------------+------------
#     (1) WAR to get around bug
#     (2) Replace programs handler with our own

sub _capture_warn_check {
	my $self = shift;

	if (!defined $SIG{__WARN__} ) {
		return $^V lt v5.8 ? 1 : 0;
	}
	return $self->{'FORCE_CAPTURE_WARN'} ? 1 : 0;
}
1;

__END__

#line 380
