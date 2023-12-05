# @summary Configure various environment settings for users
#
# @example
#   include profile_user_environment
class profile_user_environment {
  include profile_user_environment::history
  include profile_user_environment::timeout
  include profile_user_environment::quota
}
