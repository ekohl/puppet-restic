if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
  package { 'epel-release':
    ensure => installed,
  }
}
