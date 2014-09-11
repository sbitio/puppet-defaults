class defaults {

  # NG
  ## root
  include ::defaults::root_user
  ## sshkeys
  $sshkey_defaults = hiera('defaults::sshkey::defaults', {})
  $sshkeys         = hiera_hash('defaults::sshkeys', {})
  create_resources('sshkey', $sshkeys, $sshkey_defaults)
  ## useraccounts
  $useraccount_defaults = hiera('defaults::useraccount::defaults', {})
  $useraccounts         = hiera_hash('defaults::useraccounts', {})
  create_resources('defaults::useraccount', $useraccounts, $useraccount_defaults)
  ## groups
  $groups         = hiera_array('defaults::groups', {})
  group { $groups:
    ensure => present,
  }
  ## packages
  $extra_packages = hiera_array('defaults::extra_packages', [])
  ensure_packages($extra_packages)
  ## hosts
  $host_defaults = hiera('defaults::host::defaults', {})
  $hosts         = hiera_hash('defaults::hosts', {})
  create_resources('host', $hosts, $host_defaults)
  ## scripts
  $script_defaults = hiera('defaults::script::defaults', {})
  $scripts         = hiera_hash('defaults::scripts', {})
  create_resources('defaults::script', $scripts, $script_defaults)

}
