# Puppet defaults module

[![puppet forge version](https://img.shields.io/puppetforge/v/sbitio/defaults.svg)](http://forge.puppetlabs.com/sbitio/defaults) [![last tag](https://img.shields.io/github/tag/sbitio/puppet-defaults.svg)](https://github.com/sbitio/puppet-defaults/tags)

This is a facilitator module that allows the creation of
built-in resource types instances from Hiera data.

## Supported resource types

Those are the resource types currently supported. More types will be added
as we find the need, or someone does a request (PRs welcome!).

 * users, groups and ssh keys
 * packages
 * hosts
 * files
 * execs

In addition to basic resource types, there's also support for some common
needs:

 * certificates: Copy certificate files (pem, cert, ca, key) and set permissions
 * scripts: Copy scripts and configure cronjobs on them

## Implementation details

In general we apply this pattern:

```ruby
$host_defaults = hiera('defaults::host::defaults', {})
$hosts         = hiera_hash('defaults::hosts', {})
create_resources('host', $hosts, $host_defaults)
```

That is, there's a hiera key (`defaults::host::defaults`) to define defaults
applicable to any resource of the given type, and another key to actually
define the resources (`defaults::hosts`).

In general all parameters are passed directly to the resource without any
processing.

There're some exceptions, for example for users we provide a `useraccount`
defined type that manages the user, its groups and ssh keys all together.

Other exception is packages. We support both `defaults::packages` per above
pattern and also a plain list of packages in `defaults::extra_packages`.

## Example hiera

This is an example of some supported resource types. See [manifests/init.pp](https://github.com/sbitio/puppet-defaults/blob/master/manifests/init.pp)
for details on each type.

```yaml

defaults::packages :
  molly-guard :
    provider : 'rpm'
    source   : "https://github.com/tmhorne/molly-guard/blob/master/rpmbuild/RPMS/noarch/molly-guard-0.4.5-1.1.el6.noarch.rpm?raw=true"
  setuptools:
    provider : 'pip'
    ensure   : 'latest'

defaults::extra_packages :
  - 'debian-goodies'
  - 'heirloom-mailx'
  - 'lsb-base'
  - 'lsb-release'

defaults::groups :
  - 'teamA'
  - 'teamB'

# User accounts with groups and keys.
defaults::useraccount :
  scott:
    groups   : ['teamA', 'admin']
    password : '$6$6xLYYiQw$1y0AjVObt2iSX3bL....................'
    ssh_keys :
      desktop :
        type : 'ssh-rsa'
        key  : 'AAAA.....=='
      laptop  :
        type : 'ssh-rsa'
        key  : 'AAAA.....=='
      stolen  :
        ensure : absent
  tiger:
    ensure: absent

# Hosts.
defaults::host::defaults:
  ip : 172.16.1.1

# `puppet` and `puppetdb` hosts uses default ip.
defaults::hosts :
  puppet   : {}
  puppetdb : {}
  another  :
    ip     : 172.16.1.2
  legacy   :
    ensure : absent

# Certificates.
defaults::certs :
  sbit.io :
    ca   : "puppet:///files/certs/sbit.io.ca"
    cert : "puppet:///files/certs/sbit.io.cert"
    key  : "puppet:///files/certs/sbit.io.key"

  sbitmedia.com :
    ca    : "puppet:///files/certs/sbitmedia.com.ca"
    pem   : "puppet:///files/certs/sbitmedia.com.pem"

```

## License

MIT License, see LICENSE file

## Contact

Use contact form on http://sbit.io

## Support

Please log tickets and issues on [GitHub](https://github.com/sbitio/puppet-defaults)

