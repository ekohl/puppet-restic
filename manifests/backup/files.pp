# @summary Run a backup for files
#
# @param paths
#   The file paths to backup
# @param excludes
#   The file paths to exclude form the backup
# @param password
#   The password on the repository
# @param repository
#   The repository to backup to
#
# @example Back up /home and /etc to target
#   restic::backup::files { 'target':
#     paths      => ['/home', '/etc'],
#     repository => 'sftp:USERNAME@HOST:restic-repo',
#   }
#
define restic::backup::files (
  Array[Stdlib::Absolutepath, 1] $paths,
  Variant[String[1], Sensitive[String[1]]] $password,
  Variant[String[1], Sensitive[String[1]]] $repository,
  Array[Stdlib::Absolutepath] $excludes = [],
) {
  require restic::files

  $env_file = "/etc/restic/${name}.env"
  $files_file = "/etc/restic/${name}.files"
  $exclude_file = "/etc/restic/${name}.exclude"

  file { $env_file:
    ensure    => file,
    owner     => 'root',
    group     => $restic::group,
    mode      => '0640',
    content   => "RESTIC_PASSWORD='${password}'\nRESTIC_REPOSITORY='${repository}'\n",
    show_diff => false,
  }

  file { $files_file:
    ensure  => file,
    owner   => 'root',
    group   => $restic::group,
    mode    => '0640',
    content => join($paths + [''], "\n"),
  }

  file { $exclude_file:
    ensure  => file,
    owner   => 'root',
    group   => $restic::group,
    mode    => '0640',
    content => join($excludes + [$restic::homedir, ''], "\n"),
  }

  service { "restic@${name}.timer":
    ensure  => running,
    enable  => true,
    require => File[$env_file, $files_file, $exclude_file],
  }
}
