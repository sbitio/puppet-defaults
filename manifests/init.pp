class defaults {
  create_resources(defaults::useraccount, hiera_hash('useraccount', {}))
  $groups = hiera_array('groups')
  group { $groups:
    ensure => present,
  }
  $extra_packages = hiera_array('extra_packages', [])
  package { $extra_packages:
    ensure => present,
  }
  if defined(sudo::conf){
    $sudo_passwd_polycy = hiera('sudo_passwd_polycy', 'PASSWD')
    $sudo_groups        = hiera_array('sudo_groups', [])
    if $sudo_groups != [] {
      Group[$sudo_groups] -> Sudo::Conf <| |>
      $sudo_content = template('defaults/sudo_groups.erb')
      sudo::conf { 'defaults_sudo_groups':
        priority => 10,
        content  => $sudo_content,
      }
    }
  }
#  $forward_root_email = hiera('forward_root_email', [])
#  if $forward_root_email != [] {
#    mailalias { 'root':
#      ensure    => present,
#      recipient => $forward_root_email,
#    }
#  }
}
