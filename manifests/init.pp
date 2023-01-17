# @summary
#   Module to install Restic and manage backups
#
# @param user
#   The user to create who owns the backup files.
#
# @param group
#   The group to create who owns the backup files.
#
# @param package_manage
#   Enable to manage the Restic package install.
#
# @param package_ensure
#   The version of Restic to install.
#
# @param package_name
#   The name of the Restic package to install.
#
# @param homedir
#   The home directory of the managed user.
#
# @param homedir_manage
#   Whether to manage the home directory or not.
#
class restic (
  String $user = 'restic',
  String $group = 'restic',
  Boolean $package_manage = true,
  String $package_ensure = installed,
  String $package_name = 'restic',
  Stdlib::Absolutepath $homedir = '/var/lib/restic',
  Boolean $homedir_manage = true,
) {
  if $package_manage {
    package { $package_name:
      ensure => $package_ensure,
      before => File['/etc/restic'],
    }
  }

  group { $group:
    ensure => present,
    system => true,
  }

  user { $user:
    ensure => present,
    gid    => $group,
    system => true,
    home   => $homedir,
    shell  => '/usr/sbin/nologin',
  }

  if $homedir_manage {
    file { $homedir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0750',
    }
  }

  file { '/etc/restic':
    ensure => directory,
    owner  => 'root',
    group  => $group,
    mode   => '0750',
  }
}
