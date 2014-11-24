define defaults::script (
  $ensure  = present,
  $basedir = undef,
  $source  = undef,
  $cron    = {},
) {

  # Ensure basedir.
  $ensure_dir = $ensure ? {
    present => directory,
    default => $ensure
  }
  $basedir_real = pick($basedir, $::defaults::params::scripts_basedir)
  ensure_resource('file', $basedir_real, {ensure => $ensure_dir})

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
  if $cron {
    $cron_params = {
      ensure => $ensure,
      command => $script_path,
    }
    create_resources('cron', { "cron-script-${filename}" => $cron }, $cron_params)
  }

}

