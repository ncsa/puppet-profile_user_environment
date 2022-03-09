# @summary Configure session timeouts for all users
#
#
# @param limit_ssh_hours
#   Number of elapsed hours to limit a ssh session.
#   A value of <= 0 results in NO limit.
#
# @param session_minutes
#   Number of minutes of idle before session times out and ends.
#
# @example
#   include profile_user_environment::timeout
class profile_user_environment::timeout (
  Integer $limit_ssh_hours,
  Integer $session_minutes,
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

  if ( $limit_ssh_hours > 0 ) {
    file { '/root/cron_scripts/limit_ssh_hours.sh':
      mode   => '0700',
      source => "puppet:///modules/${module_name}/root/cron_scripts/limit_ssh_hours.sh",
    }
    cron { 'limit_ssh_hours':
      command => "/root/cron_scripts/limit_ssh_hours.sh -t ${limit_ssh_hours} >/dev/null 2>&1",
      minute  => [0, 20, 40],
    }
  } else {
    file { '/root/cron_scripts/limit_ssh_hours.sh':
      ensure => absent,
    }
    cron { 'limit_ssh_hours':
      ensure => absent,
    }
  }

}
