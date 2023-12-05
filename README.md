# profile_user_environment

![pdk-validate](https://github.com/ncsa/puppet-profile_user_environment/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_user_environment/workflows/yamllint/badge.svg)

NCSA Common Puppet Profile - configure user environment

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with profile_user_environment](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Dependencies](#dependencies)
1. [Reference](#reference)


## Description

This puppet profile customizes default environment settings for users.

Currently it configures the following:
- History configuration
- Session timeout
- (Optionally) run quota command(s) at login for non-root users

## Setup

Include profile_user_environment in a puppet profile file:
```ruby
include ::profile_user_environment
```

## Usage

The goal is that no parameters are required to be set. The default parameters should work for most NCSA deployments out of the box.

If you'd like to have one or more quota commands run at login you'll need to define one or more paths for the `profile_user_environment::quota::command_paths` parameter.


## Dependencies

N/A


## Reference

See: [REFERENCE.md](REFERENCE.md)
