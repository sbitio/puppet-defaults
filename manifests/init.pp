# == Class: defaults
#
class defaults (
  Array $groups,
  Hash $cron_defaults,
  Hash $crons,
  Hash $exec_defaults,
  Hash $execs,
  Hash $host_defaults,
  Hash $hosts,
  Hash $file_defaults,
  Hash $files,
  Hash $file_line_defaults,
  Hash $file_lines,
  Hash $mount_defaults,
  Hash $mounts,
  Hash $package_defaults,
  Hash $packages,
  Hash $sshkey_defaults,
  Hash $sshkeys,
  Hash $user_defaults,
  Hash $users,
  Hash $useraccount_defaults,
  Hash $useraccounts,
) {
  # Root account.
  include defaults::root_user

  ## SSH keys.
  create_resources('sshkey', $sshkeys, $sshkey_defaults)

  # User Accounts.
  create_resources('defaults::useraccount', $useraccounts, $useraccount_defaults)

  # Users.
  create_resources('user', $users, $user_defaults)

  # Groups.
  group { $groups:
    ensure => present,
  }

  # Packages.
  ensure_resources('package', $packages, $package_defaults)

  # Hosts.
  create_resources('host', $hosts, $host_defaults)

  # Crons.
  create_resources('cron', $crons, $cron_defaults)

  # Execs.
  create_resources('exec', $execs, $exec_defaults)

  # Files.
  create_resources('file', $files, $file_defaults)

  # File lines.
  create_resources('file_line', $file_lines, $file_line_defaults)

  # Mounts.
  create_resources('mount', $mounts, $mount_defaults)
}
