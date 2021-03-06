# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`profile_user_environment`](#profile_user_environment): Configure various environment settings for users
* [`profile_user_environment::history`](#profile_user_environmenthistory): Configure default history environment for all users
* [`profile_user_environment::timeout`](#profile_user_environmenttimeout): Configure session timeouts for all users

## Classes

### <a name="profile_user_environment"></a>`profile_user_environment`

Configure various environment settings for users

#### Examples

##### 

```puppet
include profile_user_environment
```

### <a name="profile_user_environmenthistory"></a>`profile_user_environment::history`

Configure default history environment for all users

#### Examples

##### 

```puppet
include profile_user_environment::history
```

#### Parameters

The following parameters are available in the `profile_user_environment::history` class:

* [`filename`](#filename)
* [`size`](#size)

##### <a name="filename"></a>`filename`

Data type: `String`

Name of history file.
This string will be prepended by either '.bash_' or '.csh_' for the actual file.

##### <a name="size"></a>`size`

Data type: `Integer`

Number of history records to keep in history file.

### <a name="profile_user_environmenttimeout"></a>`profile_user_environment::timeout`

Configure session timeouts for all users

#### Examples

##### 

```puppet
include profile_user_environment::timeout
```

#### Parameters

The following parameters are available in the `profile_user_environment::timeout` class:

* [`limit_ssh_hours`](#limit_ssh_hours)
* [`session_minutes`](#session_minutes)

##### <a name="limit_ssh_hours"></a>`limit_ssh_hours`

Data type: `Integer`

Number of elapsed hours to limit a ssh session.
A value of <= 0 results in NO limit.

##### <a name="session_minutes"></a>`session_minutes`

Data type: `Integer`

Number of minutes of idle before session times out and ends.

