define defaults::cert(
  $ensure  = present,
  $basedir = undef,
  $pem     = undef,
  $key     = undef,
  $cert    = undef,
  $ca      = undef,
  $user    = 'root',
  $group   = 'root',
  $mode    = '400',
) {

  $basedir_real = pick($basedir, $::defaults::params::certs_basedir)
  $certdir = "${basedir_real}/${name}"

  $ensure_dir = $ensure ? {
    present => directory,
    default => $ensure
  }
  ensure_resource('file', [$basedir_real, $certdir], {ensure => $ensure_dir})

  $params = {
    ensure  => $ensure,
    certdir => $certdir,
    source  => $source,
    user    => $user,
    group   => $group,
    mode    => $mode,
  }

  if $pem {
    $pem_params = {
      source => $pem,
    }
    ensure_resource('defaults::cert::file', "${name}.pem", merge($pem_params, $params))
  }

}

define defaults::cert::file(
  $ensure,
  $certdir,
  $source,
  $user,
  $group,
  $mode,
) {
  file { "${certdir}/${name}":
    ensure => $ensure,
    source => $source,
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }
}

