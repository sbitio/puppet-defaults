define defaults::script (
  $ensure  = present,
  $basedir = undef,
  $source  = undef,
  $cron    = {},
) {

  $basedir_real = pick($basedir, $::defaults::params::scripts_basedir)
  # Ensure basedir only if present to avoid conflicting duplicate declarations.
  if $ensure == 'present' {
    ensure_resource('file', $basedir_real, { ensure => 'directory' })
  }

  # Ensure script.
  $filename    = regsubst($name, '/', '_')
  $script_path = "${basedir_real}/${filename}"
  $source_real = pick($source, $::defaults::params::scripts_source)
  file { $script_path:
    ensure  => $ensure,
    source  => "${source_real}/${name}",
    require => File[$basedir_real],
  }

  # Cron task.
  if $cron != {} {
    $cron_params = {
      ensure => $ensure,
      command => $script_path,
    }
    create_resources('cron', { "cron-script-${filename}" => $cron }, $cron_params)
  }

}

