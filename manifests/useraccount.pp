# == Defined type: defaults::useraccount
#
# Based on https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
#
define defaults::useraccount(
  $ensure   = present,
  $uid      = '',
  $gid      = undef,
  $home     = "/home/${name}",
  $groups   = [],
  $shell    = '/bin/bash',
  $password = '',
  $fullname = $title,
  $ssh_keys = {}
) {

  $username = $name

  user { "$username":
    ensure     => $ensure,
    gid        => $gid ? {
      undef   => $username,
      default => $gid,
    },
    groups     => $groups,
    comment    => "$fullname,,,",
    home       => $home,
    shell      => $shell,
    allowdupe  => false,
    managehome => true,
    uid        => $uid,
  }
  group { "$username":
    ensure => $ensure,
    gid    => $gid,
  }
  # Ordering of dependencies, just in case
  case $ensure {
    present: {
      User <| title == "$username" |> { require => Group["$username"] }
    }
    absent: {
      Group <| title == "$username" |> { require => User["$username"] }
    }
  }
  # Set password if available
  if $password != '' {
    User <| title == "$username" |> { password => $password }
  }

  Ssh_authorized_key {
    user    => $username,
  }
  # TODO: add helper define to avoid key_name collitions
  #notify {"user keys: ${ssh_keys}":}
  if $ssh_keys != {} and $ensure == present {
    create_resources(ssh_authorized_key, $ssh_keys)
  }

}
