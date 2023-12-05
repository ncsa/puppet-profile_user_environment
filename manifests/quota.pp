# @summary Install login scripts to run user quota commands.
#
# Install login scripts to run user quota commands.
#
# @param command_paths
#   Paths to commands/scripts to run to display user
#   quota information. Leave empty to NOT run any
#   quota commands at login.
#
# @param file_prefix
#   Run-script files will be added for various shells in /etc/profile.d/
#   to wrap the quota scripts. This parameter specifies the prefix for
#   the filenames of these run-scripts. The entire name will end up being
#   ${file_prefix}_quota.[extension]. A prefix is useful to avoid collisions
#   and control the order of execution in relation to other scripts in
#   /etc/profile.d/.
#
# @param skip_users
#   When these users log in quota commands will NOT be run.
#
# @param timeout_interval_seconds
#   Each quota command is wrapped in 'timeout' and will be aborted after
#   this number of seconds. Can be useful to prevent long "hangs" at
#   login if there are filesystem problems.
#
# @example
#   include profile_user_environment::quota
class profile_user_environment::quota (
  Array   $command_paths,
  String  $file_prefix,
  Array   $skip_users,
  Integer $timeout_interval_seconds,
) {
  # defaults for file resources
  File {
    group => 'root',
    mode => '0644',
    owner => 'root',
  }

  $bash_file="/etc/profile.d/${file_prefix}_quota.sh"
  $csh_file="/etc/profile.d/${file_prefix}_quota.csh"

  if $command_paths.empty {
    # no quota scripts to run, remove run-scripts
    ## Bash-like shells
    file { $bash_file:
      ensure => absent,
    }
    ## csh-like shells
    file { $csh_file:
      ensure => absent,
    }
  } else {
    # quota script(s) listed, manage run-scripts
    ## Bash-like shells
    file { $bash_file:
      ensure  => file,
      content => epp( 'profile_user_environment/quota.sh.epp' ),
    }
    ## csh-like shells
    file { $csh_file:
      ensure  => file,
      content => epp( 'profile_user_environment/quota.csh.epp' ),
    }
  }
}
