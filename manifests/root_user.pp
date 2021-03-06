# == Class: defaults::root_user
#
class defaults::root_user (
  $password            = undef,
  $ssh_authorized_keys = {},
) {

  if $password != undef {
    ensure_resource(
      'user',
      'root',
      {
        password => $password,
      }
    )
  }
  create_resources(
    'ssh_authorized_key',
    $ssh_authorized_keys,
    {
      user => 'root',
    }
  )

}

