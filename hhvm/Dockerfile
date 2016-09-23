#++++++++++++++++++++++++++++++++++++++++++++#
#      HHVM Docker container in Alpine       #
#++++++++++++++++++++++++++++++++++++++++++++#

##http://ftp.twaren.net/Linux/OpenSuSE/repositories/devel:/libraries:/c_c++/openSUSE_Leap_42.1/x86_64/libtbb2-2017_20160722-8.1.x86_64.rpm
##http://ftp.twaren.net/Linux/OpenSuSE/repositories/devel:/libraries:/c_c++/openSUSE_Leap_42.1/x86_64/libtbbmalloc2-2017_20160722-8.1.x86_64.rpm
##http://ftp.twaren.net/Linux/OpenSuSE/repositories/devel:/libraries:/c_c++/openSUSE_Leap_42.1/x86_64/tbb-devel-2017_20160722-8.1.x86_64.rpm
  # GeoIP-data Mesa Mesa-libEGL1 Mesa-libGL1 Mesa-libglapi0 boost-license1_54_0 cron cronie dbus-1-x11 fontconfig fribidi
  # gd gdk-pixbuf-query-loaders gio-branding-openSUSE glib2-tools hhvm hhvm-fastcgi hhvm-nginx libGeoIP1 libHalf11
  # libIex-2_1-11 libIlmImf-Imf_2_1-21 libIlmThread-2_1-11 libLLVM libMagickCore-6_Q16-1 libMagickWand-6_Q16-1 libX11-6
  # libX11-data libX11-xcb1 libXau6 libXdamage1 libXext6 libXfixes3 libXft2 libXpm4 libXrender1 libXxf86vm1
  # libboost_context1_54_0 libboost_filesystem1_54_0 libboost_program_options1_54_0 libboost_system1_54_0
  # libboost_thread1_54_0 libc-client2007e_suse libcairo2 libcroco-0_6-3 libdb-4_8 libdouble-conversion1 libdrm2
  # libdrm_amdgpu1 libdrm_intel1 libdrm_nouveau2 libdrm_radeon1 libdwarf libedit0 libelf0 libevent-2_0-5 libfreetype6
  # libgbm1 libgdbm4 libgdk_pixbuf-2_0-0 libgio-2_0-0 libglib-2_0-0 libglog0 libgmodule-2_0-0 libgobject-2_0-0 libgomp1
  # libgraphite2-3 libharfbuzz0 libicu52_1 libicu52_1-data libjasper1 libjbig2 libjemalloc2 libjpeg8 liblcms2-2 libltdl7
  # liblz4-1_4 libmcrypt libmemcached11 libncurses6 libnuma1 libonig2 libpango-1_0-0 libpciaccess0 libpixman-1-0
  # libpng16-16 libpq5 librsvg-2-2 libsqlite3-0 libtbb2 libtiff5 libvpx1 libwayland-client0 libwayland-server0 libwebp5
  # libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-render0 libxcb-shm0 libxcb-sync1 libxcb-xfixes0 libxcb1
  # libxshmfence1 libxslt1 libyaml-0-2 libzip2 logrotate nginx pango-tools perl pkg-config shared-mime-info timezone
  # unixODBC wallpaper-branding-openSUSE

FROM opensuse:42.1
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV HHVM_HOME=/usr/local \
    HHVM_VERSION=3.15.0 \
    HHVM_DATA=/mnt

COPY entry /usr/bin/
RUN set -e \
    && chmod u+x /usr/bin/entry \
    # To install Dependecies
    && zypper addrepo http://download.opensuse.org/repositories/home:munix9/openSUSE_Leap_42.1/home:munix9.repo \
    && zypper --gpg-auto-import-keys install -y hhvm hhvm-fastcgi \
    && mkdir /tmp/etc \
    && mv /etc/hhvm/* /tmp/etc/
    
VOLUME $HHVM_DATA
EXPOSE 9000
ENTRYPOINT ["entry"]
CMD ['hhvm', '-c', '$HHVM_DATA/etc/php.ini', '-c', '$HHVM_DATA/etc/php.ini', '-m', 's', '-u', 'hhvm']