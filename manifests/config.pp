class reprepro::config {

	file { $basedir:
		ensure  => directory,
		force   => true,
		recurse => true,
		owner   => root,
		group   => www-data,
		mode    => 0750, # read + execute
	}

	nginx::vhost::snippet { 'reprepro':
		vhost   => 'default',
		content => template('reprepro/nginx_vhost.erb'),
		ensure  => $reprepro::ensure
	 }
}
