cd /var/packages/ubuntu
reprepro includedeb raring raar_debian_etch_4.0r8.x86_64.deb
reprepro -b /var/packages/ubuntu includedeb raring sublime-text_build-3021_*.deb

find /var/packages/ -exec chown root:www-data '{}' \;

UMASK?? (0127) (-rw-r-----)
