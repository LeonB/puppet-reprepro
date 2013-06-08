# http://joseph.ruscio.org/blog/2010/08/19/setting-up-an-apt-repository/
# https://github.com/camptocamp/puppet-reprepro/blob/master/manifests/repository.pp
# http://wiki.debian.org/SettingUpSignedAptRepositoryWithReprepro
# http://davehall.com.au/blog/dave/2010/02/06/howto-setup-private-package-repository-reprepro-nginx

class reprepro(
  $package_name = params_lookup( 'package_name' ),
  $enabled      = params_lookup( 'enabled' ),
  $basedir      = params_lookup( 'basedir' ),
  ) inherits reprepro::params {

    $ensure = $enabled ? {
      true => present,
      false => absent
    }

  include reprepro::package, reprepro::config
}
