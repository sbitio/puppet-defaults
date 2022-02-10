# defaults::cert::file
#
# This defined type is responsible of creating a file with the given parameters
#
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
