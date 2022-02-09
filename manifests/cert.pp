# == Defined type: defaults::cert
#
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
  if $key {
    $key_params = {
      source => $key,
    }
    ensure_resource('defaults::cert::file', "${name}.key", merge($key_params, $params))
  }
  if $cert {
    $cert_params = {
      source => $cert,
    }
    ensure_resource('defaults::cert::file', "${name}.cert", merge($cert_params, $params))
  }
  if $ca {
    $ca_params = {
      source => $ca,
    }
    ensure_resource('defaults::cert::file', "${name}.ca", merge($ca_params, $params))
  }

}
