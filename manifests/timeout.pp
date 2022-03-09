# @summary Setup session timeouts for all users
#
# @param session_minutes
#   Number of minutes of idle before session times out and ends.
#
# @param limit_ssh_to_24hr
#   Whether to limit ssh sessions to 24 hours
#
# @param limit_ssh_to_24hr_packages
#   List of required packages to install to support the limit_ssh_to_24hr script
#
# @example
#   include profile_user_environment::timeout
class profile_user_environment::timeout (
  Integer $session_minutes,
  Boolean $limit_ssh_to_24hr,
  Array[String] $limit_ssh_to_24hr_packages,
) {

  if ( $session_minutes > 0 ) {
    $session_seconds = $session_minutes * 60
    file { '/etc/profile.d/timeout.csh':
      mode    => '0644',
      content => template('profile_user_environment/timeout.csh.erb'),
    }
    file { '/etc/profile.d/timeout.sh':
      mode    => '0644',
      content => template('profile_user_environment/timeout.sh.erb'),
    }
  }

  if ( $limit_ssh_to_24hr) {
    ensure_packages($limit_ssh_to_24hr_packages)
    file { '/root/cron_scripts/limit_ssh_to_24hr.pl':
      mode   => '0700',
      source => "puppet:///modules/${module_name}/root/cron_scripts/limit_ssh_to_24hr.pl",
    }
    cron { 'limit_ssh_to_24hr':
      command => '/root/cron_scripts/limit_ssh_to_24hr.pl',
      minute  => [0, 20, 40],
    }
  }

}
