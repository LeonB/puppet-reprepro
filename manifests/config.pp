class reprepro::config {

  file { $reprepro::basedir:
    ensure  => directory,
    force   => true,
    recurse => true,
    owner   => root,
    group   => www-data,
    mode    => '0750', # read + execute
  }

  nginx::vhost { "repo.${::domain}":
    root => '/var/packages',
  }

  nginx::vhost::snippet { 'autoindex':
    ensure  => $reprepro::ensure,
    vhost   => "repo.${::domain}",
    content => template('reprepro/nginx_vhost.erb'),
  }
}
