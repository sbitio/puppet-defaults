# basado en https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
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
  }
  group { "$username":
    ensure => $ensure,
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

  #TODO Asegurar que no se rompen los ids
  # uid/gid management
  if $uid != '' {
    # Manage uid if etcpass is available
    if $etcpasswd != '' {
      User <| title == "$username" |> { uid => $uid }
#      users::uidsanity { "$uid": username => $username }
    }
    # Manage gid if etcgroup is available
    if $etcgroup != '' {
      User <| title == "$username" |> { gid => $uid }
      Group <| title == "$username" |> { gid => $uid }
#      users::gidsanity { "$uid": groupname => $username }
    }
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
