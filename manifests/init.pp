# == Class: defaults
#
class defaults inherits ::defaults::params {

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

  # Users.
  $user_defaults = hiera('defaults::user::defaults', {})
  $users         = hiera_hash('defaults::users', {})
  create_resources('user', $users, $user_defaults)

  # Groups.
  $groups = hiera_array('defaults::groups', [])
  group { $groups:
    ensure => present,
  }

  # Packages.
  $packages_defaults = hiera('defaults::packages::defaults', {})
  $packages          = hiera_hash('defaults::packages', {})
  ensure_resources('package', $packages, $packages_defaults)

  # Hosts.
  $host_defaults = hiera('defaults::host::defaults', {})
  $hosts         = hiera_hash('defaults::hosts', {})
  create_resources('host', $hosts, $host_defaults)

  # Crons.
  $cron_defaults = hiera('defaults::cron::defaults', {})
  $crons         = hiera_hash('defaults::crons', {})
  create_resources('cron', $crons, $cron_defaults)

  # Execs.
  $exec_defaults = hiera('defaults::exec::defaults', {})
  $execs         = hiera_hash('defaults::execs', {})
  create_resources('exec', $execs, $exec_defaults)

  # Files.
  $files_defaults = hiera('defaults::file::defaults', {})
  $files          = hiera_hash('defaults::files', {})
  create_resources('file', $files, $files_defaults)

  # File lines.
  $file_line_defaults = hiera('defaults::file_line::defaults', {})
  $file_lines          = hiera_hash('defaults::file_lines', {})
  create_resources('file_line', $file_lines, $file_line_defaults)

  # Mounts.
  $mounts_defaults = hiera('defaults::mount::defaults', {})
  $mounts          = hiera_hash('defaults::mounts', {})
  create_resources('mount', $mounts, $mounts_defaults)
}
