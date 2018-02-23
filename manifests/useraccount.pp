# == Defined type: defaults::useraccount
#
# Based on https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
#
define defaults::useraccount(
  $ensure   = present,
  $uid      = undef,
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

  # Create authorized keys
  $ssh_keys.each |$name, $params| {
    ssh_authorized_key { "${username}-${name}":
      ensure => $ensure,
      user   => $username,
      *      => $params,
    }
  }

}
