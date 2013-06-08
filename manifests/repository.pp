define reprepro::repository (
  $ensure = present,
  $distributions = [],
) {

  include reprepro
  $basedir = $reprepro::basedir
  $directory_ensure = $ensure ? { present => directory, default => $ensure }

  file {
    [
      "${basedir}/${name}/",
      "${basedir}/${name}/dists/",
      "${basedir}/${name}/pool/",
    ]:
      ensure  => $directory_ensure,
      force   => true,
      recurse => true,
      owner   => root,
      group   => www-data,
      mode    => '0640'; # rwx,rx

    [
      "${basedir}/${name}/conf/",
      "${basedir}/${name}/db/",
    ]:
      ensure  => $directory_ensure,
      force   => true,
      recurse => true,
      owner   => root,
      group   => www-data,
      mode    => '0600'; # rwx

    # [
    # "${basedir}/${name}/conf/distributions",
    # ]:
    #   ensure  => $ensure,
    #   force   => true,
    #   recurse => true,
    #   owner   => root,
    #   group   => www-data,
    #   mode    => 0600, # read + execute
    #   content => template('reprepro/distributions.erb');
  }


  concat {"${basedir}/${name}/conf/distributions":
    owner   => root,
    group   => www-data,
    mode    => 0600,
    force   => true,
    require => File["${basedir}/${name}/conf/"],
  }

}
