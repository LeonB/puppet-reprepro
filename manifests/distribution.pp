define reprepro::distribution (
	$repository,
	$ensure = present,
	$template = "reprepro/distributions/${repository}/${name}.erb",
 ) {

 	$basedir = $reprepro::basedir

	concat::fragment {"distibution-${repository}-${name}":
		ensure  => $ensure,
		target  => "${basedir}/${repository}/conf/distributions",
		content => template($template),
		notify  => $ensure ? {
			'present' => Exec["export distribution ${name}"],
			default   => undef,
		},
	}

	# FIXME: this exec don't works with user=>reprepro ?!?
	exec {"export distribution ${name}":
		command     => "/usr/bin/reprepro -b ${basedir}/${repository} export ${name}",
		refreshonly => true,
		# require     => [User[reprepro], Reprepro::Repository[$repository]],
		require     => Reprepro::Repository[$repository],
		user        => 'root',
		group       => 'www-data',
	}

}
