# == Defined type: defaults::useraccount
#
# Based on https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
#
define defaults::useraccount(
  $ensure         = present,
  $uid            = undef,
  $gid            = undef,
  $home           = "/home/${name}",
  $mode           = '0755',
  $managehome     = true,
  $groups         = [],
  $shell          = '/bin/bash',
  $password       = '',
  $fullname       = $title,
  $purge_ssh_keys = false,
  $ssh_keys       = {}
) {

  $username = $name
  $_real_gid = $gid ? {
    undef   => $username,
    default => $gid,
  }

  user { "$username":
    ensure         => $ensure,
    gid            => $_real_gid,
    groups         => $groups,
    comment        => "$fullname,,,",
    home           => $home,
    shell          => $shell,
    allowdupe      => false,
    managehome     => $managehome,
    uid            => $uid,
    purge_ssh_keys => $purge_ssh_keys,
  }
  group { "$username":
    ensure => $ensure,
    gid    => $gid,
  }
  if $managehome {
    file { $home:
      mode => $mode,
      require => User[$username],
    }
  }

  # Ordering of dependencies, just in case
  case $ensure {
    present: {
      User <| title == "$username" |> { require => Group["$username"] }
    }
    absent: {
      Group <| title == "$username" |> { require => User["$username"] }
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  # Set password if available
  if $password != '' {
    User <| title == "$username" |> { password => $password }
  }

  # Create authorized keys
  if ($ensure == present) {
    $ssh_keys.each |$name, $params| {
      $params_defaults = {
        user => $username,
      }
      ssh_authorized_key { "${username}-${name}":
        * => merge($params_defaults, $params),
      }
    }
  }

}
