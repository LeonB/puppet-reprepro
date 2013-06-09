define reprepro::distribution (
  $repository,
  $origin = $::domain,
  $label = $::domain,
  $architectures = ['i386', 'amd64', 'armhf'],
  $components = ['main'],
  $description = "${::domain} Repository",
  $ensure = present,
  $template = 'reprepro/distribution.erb',
  $distribution = $name,
) {

  $basedir = $reprepro::basedir
  $directory_ensure = $ensure ? { present => directory, default => $ensure }

  file { "${basedir}/${repository}/dists/${distribution}/":
    ensure  => $directory_ensure,
    force   => true,
    recurse => true,
    owner   => root,
    group   => www-data,
    mode    => '0640', # rwx,rx
    require => Reprepro::Repository[$repository],
  }

  concat::fragment {"distibution-${repository}-${distribution}":
    ensure  => $ensure,
    target  => "${basedir}/${repository}/conf/distributions",
    content => template($template),
    notify  => $ensure ? {
      'present' => Exec["export distribution ${distribution}"],
      default   => undef,
    },
  }

  # FIXME: this exec don't works with user=>reprepro ?!?
  exec {"export distribution ${distribution}":
    command     => "/usr/bin/reprepro -b ${basedir}/${repository} export ${distribution}",
    refreshonly => true,
    user        => 'root',
    group       => 'www-data',
    require     => Reprepro::Repository[$repository],
  }

  # Check if architectures contains source
  if inline_template('<%= architectures.include?("source") %>') == true {
    $include_src = true
  } else {
    $include_src = false
  }

  # Apt::Source <<| release == $::lsbdistcodename |>>
  @@apt::source { "repo.${::domain}":
    location    => "http://repo.${::domain}/${repository}",
    release     => $distribution,
    include_src => $include_src,
  }

}
