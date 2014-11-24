class defaults inherits defaults::params {

  # Root account.
  include ::defaults::root_user

  ## SSH keys.
  $sshkey_defaults = hiera('defaults::sshkey::defaults', {})
  $sshkeys         = hiera_hash('defaults::sshkeys', {})
  create_resources('sshkey', $sshkeys, $sshkey_defaults)

  # User Accounts.
  $useraccount_defaults = hiera('defaults::useraccount::defaults', {})
  $useraccounts         = hiera_hash('defaults::useraccounts', {})
  create_resources('defaults::useraccount', $useraccounts, $useraccount_defaults)

  # Groups.
  $groups = hiera_array('defaults::groups', {})
  group { $groups:
    ensure => present,
  }

  # Packages.
  $extra_packages = hiera_array('defaults::extra_packages', [])
  ensure_packages($extra_packages)

  # Hosts.
  $host_defaults = hiera('defaults::host::defaults', {})
  $hosts         = hiera_hash('defaults::hosts', {})
  create_resources('host', $hosts, $host_defaults)

  # Scripts.
  $script_defaults = hiera('defaults::script::defaults', {})
  $scripts         = hiera_hash('defaults::scripts', {})
  create_resources('defaults::script', $scripts, $script_defaults)

  # Cerificates.
  $cert_defaults = hiera('defaults::certs::defaults', {})
  $certs         = hiera_hash('defaults::certs', {})
  create_resources('defaults::cert', $certs, $cert_defaults)

}

