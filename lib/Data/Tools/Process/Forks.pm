##############################################################################
#
#  Data::Tools::Process::Forks fork process and control
#  Copyright (c) 2013-2026 Vladi Belperchinov-Shabanski "Cade" 
#        <cade@noxrun.com> <cade@bis.bg> <cade@cpan.org>
#  http://cade.noxrun.com/  
#
#  GPL
#
##############################################################################
package Data::Tools::Process::Forks;
use strict;
use Exporter;
use POSIX;
our $VERSION = '1.50';

our @ISA    = qw( Exporter );
our @EXPORT = qw(

                forks_setup_signals
                
                forks_start_one
                forks_wait_one
                forks_wait_all
                
                forks_count       
                forks_signal_all
                forks_stop_all
                forks_kill_all
                
                forks_set_max
                forks_get_max
                forks_pids
                forks_names
                
                );

my $__MAX_FORKS = 4;
my %__FORKS = ();         # maps pid to name (name is '*' for no-named-ones)

sub __sig_handler_term
{
  forks_stop_all();
  forks_wait_all();
  exit 111;
};

sub forks_setup_signals
{
  $SIG{ 'INT'  } = \&__sig_handler_term;
  $SIG{ 'TERM' } = \&__sig_handler_term;
}

sub forks_signal_all
{
  my $sig = shift // return undef;

  kill( $sig, keys %__FORKS );
}

sub forks_stop_all
{
  return forks_signal_all( 'TERM' );
}

sub forks_kill_all
{
  return forks_signal_all( 'KILL' );
}

sub forks_count
{
  return scalar( keys %__FORKS );
}

sub __wait_count
{
  my $bar = shift; # max level
  
  while( forks_count() >= $bar )
    {
    forks_wait_one();
    }
}

sub forks_wait_one
{
  my $non_blocking = shift;
  
  my $flags = $non_blocking ? WNOHANG : 0;
  
  while( forks_count() > 0 )
    {
    my $pid = waitpid( -1, $flags );
    next if $pid <= 0;
    
    my $status = $?;
    my $exit   = $status >> 8;       # exit code
    my $xsig   = $status & 127;      # exit signal
    my $name   = $__FORKS{ $pid };   # forked process name
    
    delete $__FORKS{ $pid };

    # print "    <-- exit ( $pid, $exit, $xsig, $name )\n";
    # TODO: callback with ( $pid, $exit, $xsig, $name )

    return wantarray ? ( $pid, $exit, $xsig, $name ) : $pid;
    }
  return ();
}

sub forks_wait_all
{
  __wait_count( 1 ); # wait all
}

sub forks_start_one
{
  my $name = shift || '*';
  my $sub  = shift;
  
  __wait_count( $__MAX_FORKS ); # wait count to fall below max

  my $pid = fork();
  return '0E0' unless defined $pid; # error, but will still be in the parent

  if( $pid )
    {
    # print "--> forked [$pid]\n";
    # parent here
    $__FORKS{ $pid } = $name;
    return $pid;
    }
  else
    {
    # print "           [$$] here\n";
    }  

  # child here
  exit $sub->( @_ ) if $sub; # exec sub and exit with exit code
  
  return 0;
}

sub forks_set_max
{
  my $max = shift;
  
  $max = 4 if $max < 1; # no foreground option, do not fork in higher-level logic
  
  $__MAX_FORKS = $max;
}  

sub forks_get_max
{
  return $__MAX_FORKS;
}  

sub forks_pids
{
  return keys %__FORKS;
}

sub forks_names
{
  my %n;
  $n{ $_ }++ for values %__FORKS;
  return keys %n;
}

1;
