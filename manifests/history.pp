# @summary Configure default history environment for all users
#
# @param filename
#   Name of history file.
#   This string will be prepended by either '.bash_' or '.csh_' for the actual file.
#
# @param size
#   Number of history records to keep in history file.
#
# @example
#   include profile_user_environment::history
class profile_user_environment::history (
  String  $filename,
  Integer $size,
) {

  if ( $size > 0 and ! empty($filename) ) {
    file { '/etc/profile.d/history.csh':
      mode    => '0644',
      content => template('profile_user_environment/history.csh.erb'),
    }
    file { '/etc/profile.d/history.sh':
      mode    => '0644',
      content => template('profile_user_environment/history.sh.erb'),
    }
  }

}
