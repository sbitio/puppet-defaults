class defaults {
  # OLD nodes
  create_resources(sshkey, hiera_hash('sshkeys', {}))
  create_resources(defaults::useraccount, hiera_hash('useraccount', {}))
  $groups = hiera_array('groups')
  group { $groups:
    ensure => present,
  }
  ensure_packages(hiera_array('extra_packages', []))

  # NG
  ## sshkeys
  $sshkey_defaults = hiera('defaults::sshkey::defaults', {})
  $sshkeys         = hiera_hash('defaults::sshkeys', {})
  create_resources('sshkey', $ssh_keys, $sshkey_defaults)
  ## useraccounts
  $useraccount_defaults = hiera('defaults::useraccount::defaults', {})
  $useraccounts         = hiera_hash('defaults::useraccounts', {})
  create_resources('defaults::useraccount', $useraccounts, $useraccount_defaults)
  ## groups
  $group_defaults = hiera('defaults::group::defaults', {})
  $groups         = hiera_hash('defaults::groups', {})
  create_resources('group', $groups, $group_defaults)
  ## packages
  #$package_defaults = hiera('defaults::package::defaults', {})
  $packages         = hiera_array('defaults::packages', [])
  #create_resources('package', $packages, $package_defaults)
  ensure_packages($packages)
  ## scripts
  $script_defaults = hiera('defaults::script::defaults', {})
  $scripts         = hiera_hash('defaults::scripts', {})
  create_resources('defaults::script', $scripts, $script_defaults)


  # TODO consider using virtual resources and split some functionality to ducktape
  if defined(sudo::conf){
    if hiera('sudo_passwd_polycy', '') != '' {
      notify {"DEPRECATED sudo_passwd_polycy, use sudo_passwd_policy instead" : }
    }
    $sudo_passwd_policy = hiera('sudo_passwd_policy', hiera('sudo_passwd_polycy', 'PASSWD') )
    $sudo_groups        = hiera_array('sudo_groups', [])
    if $sudo_groups != [] {
      Group[$sudo_groups] -> Sudo::Conf <| |>
      $sudo_content = template('defaults/sudo_groups.erb')
      sudo::conf { 'defaults_sudo_groups':
        priority => 10,
        content  => $sudo_content,
      }
    }
    sudo::conf { 'ansible':
      priority => 10,
      content  => 'ansible ALL=NOPASSWD: ALL',
    }
    if ($is_vagrant) {
      sudo::conf { 'vagrant':
        priority => 00,
        content  => 'vagrant ALL=NOPASSWD:ALL
Defaults:vagrant !requiretty',
      }
    }
    if ( $::ec2_ami_id != '' and $::operatingsystem == 'Debian') {
      sudo::conf { 'cloud-init-users':
        priority => 90,
        content => '# Created by cloud-init v. 0.7.2 on Tue, 25 Mar 2014 11:32:28 +0000

# User rules for admin
admin ALL=(ALL) NOPASSWD:ALL',
      }
    }
  }
}
