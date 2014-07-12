define defaults::script (
  $ensure      = present,
  $script_root = undef,
  $souce_root  = undef,
  $cron        = {},
) {
  require defaults::params
  # TODO: add stdlib dependency
  $ensure_dir = $ensure ? {
    present => directory,
    default => $ensure,
  }
  $script_root_real = $script_root ? {
    undef   => $::defaults::params::script_root,
    default => $script_root,
  }
  $source_root_real = $souce_root ? {
    undef   => $::defaults::params::source_root,
    default => $source_root,
  }
  ensure_resource(file, $script_root_real, { ensure => $ensure_dir })
  $filename = regsubst($name,'/','_')
  $full_filename = "${script_root_real}/${filename}"
  file { $full_filename :
    ensure  => $ensure ? {
      present => file, 
      default => $ensure,
    },
    source  => "${source_root_real}/${name}",
    require => File[$script_root_real],
  } 
  if ! empty($cron) {
    $cron_merge = merge({ ensure => $ensure, command => $full_filename }, $cron)
    create_resources(cron, { "defaults::script-${filename}" => $cron_merge }, {})
  } 
} 
