# == Defined type: defaults::useraccount
#
# Based on https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
#
define defaults::useraccount (
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
  $ssh_keys       = {},
  Array $subdirs  = [],
  Optional[Hash] $acl = undef
) {
  $username = $name
  $_real_gid = $gid ? {
    undef   => $username,
    default => $gid,
  }

  user { $username:
    ensure         => $ensure,
    gid            => $_real_gid,
    groups         => $groups,
    comment        => "${fullname},,,",
    home           => $home,
    shell          => $shell,
    allowdupe      => false,
    managehome     => $managehome,
    uid            => $uid,
    purge_ssh_keys => $purge_ssh_keys,
  }
  group { $username:
    ensure => $ensure,
    gid    => $gid,
  }
  if $managehome {
    file { $home:
      mode    => $mode,
      require => User[$username],
    }
    $_subdirs = unique($subdirs + ['.ssh', 'nobackup'])
    $_subdirs.each |$subdir| {
      $subdir_real = "${home}/${subdir}"
      file { $subdir_real:
        ensure => directory,
        owner  => $username,
        group  => $username,
      }
      if ($acl) {
        posix_acl { $subdir_real:
          *       => $acl,
          require => File[$subdir_real],
        }
      }
    }
  }

  # Ordering of dependencies, just in case
  case $ensure {
    'present': {
      User <| title == $username |> { require => Group[$username] }
    }
    'absent': {
      Group <| title == $username |> { require => User[$username] }
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  # Set password if available
  if $password != '' {
    User <| title == $username |> { password => $password }
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
