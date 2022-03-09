#! /bin/perl

use English;
use Data::Dumper;
use Proc::ProcessTable;
use DateTime::Duration;
use Sys::Syslog;

# get a pointer to the process table object so that we can step through
# the entire process table looking for ssh sessions
my $t = Proc::ProcessTable->new();

openlog("timeout", 0, LOG_LOCAL0);

# step through the process table.
foreach my $p (@{$t->table})
{
    # set up variables 
    my $years, $months, $days, $hours, $minutes, $seconds, $print, $outline;

    # initialize variables
    $years = $months = $days = $hours = $minutes = $seconds = $print = 0; 
    # look for ssh sessions
    next if (!($p->cmndline =~ /^sshd: /));
    # ignore NoMachine sessions (uncomment if exemption for NoMachine desired
#    next if ($p->cmndline =~ /^sshd: .*notty&/);

    # as a part of the process when a user logs in through ssh, the ssh daemon
    # will spawn a sub process as part of the login.  This process will have 
    # "[priv]" in its name and this process is the one that will spawn the first
    # process owned by the user.  We're going to ignore the root-owned [priv]
    # process and operate off of the user-owned ssh process which take the form
        # of sshd: user@tty. In this case, we only care they begin with sshd.
        # the master process is called by full path name.  As a security precaution,
        # the sshd binary WONT start unless it is called by full path name.
    next if ($p->cmndline =~ /\[priv\]/);

    # get the user name from the process owner uid
    $user = getpwuid($p->uid);

    # to get difference, we must know current time
    my $curtime = DateTime->now();

    # get start time of process
    my $procstarttime = DateTime->from_epoch( epoch => $p->start );

    # find the difference between start and now
    my $elapsed = $curtime->subtract_datetime( $procstarttime );

    # get human readable numbers
    ($years, $months, $days, $hours, $minutes, $seconds) =
        $elapsed->in_units('years', 'months', 'days', 'hours', 'minutes', 'seconds');

    #debug printing
        $outline = "sshd session for user $user has been running for ";

        $print = ($years || $print);
        $outline .= "$years years, " if ($print);

        $print = ($months || $print);
        $outline .= "$months months, " if ($print);

        $print = ($days || $print);
        $outline .= "$days days, " if ($print);

        $print = ($hours || $print);
        $outline .= "$hours hours, " if ($print); 

        $print = ($minutes || $print);
        $outline .= "$minutes minutes, " if ($print);

        $outline .= "$seconds seconds";

    # check to see if this ssh session violates the 24 hour limit
    # (if it has anything other than 0 for years, months, or days, it violates the limit
    if ($years || $months || $days)
    {
        # the following would send signal to process and process's children
        $p->kill(15);
        $outline .= ", process violates > 24 hr ssh session restriction";
        syslog(LOG_INFO, $outline);
    }
    #print "\n";
}

closelog();

