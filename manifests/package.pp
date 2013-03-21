class reprepro::package {

	package  { $reprepro::package_name:
		ensure => $reprepro::ensure,
	}
}
