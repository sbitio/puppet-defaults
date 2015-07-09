# == Class: defaults::params
#
# === Parameters
#
# [*certs_basedir*]
#   Directory in which to put the certificates.
#
# [*scripts_basedir*]
#   Directory in which to put the scripts.
#
# [*scripts_source*]
#   Puppet source to pick scripts from.
#
class defaults::params(
  $certs_basedir   = '/opt/certs',
  $scripts_basedir = '/opt/scripts',
  $scripts_source  = 'puppet:///files/scripts',
) {
}

