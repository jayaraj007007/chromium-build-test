#

# Build with:

# docker build --compress -t adieuadieu/chromium-for-amazonlinux-base:62.0.3202.62 --build-arg VERSION=62.0.3202.62 .

#

# Jump into the container with:

# docker run -i -t --rm --entrypoint /bin/bash  adieuadieu/chromium-for-amazonlinux-base

#

# Launch headless Chromium with:

# docker run -d --rm --name headless-chromium -p 9222:9222 adieuadieu/headless-chromium-for-aws-lambda

#



FROM amazonlinux:2.0.20200722.0-with-sources



# ref: https://chromium.googlesource.com/chromium/src.git/+refs

ARG VERSION

ENV VERSION ${VERSION:-master}



LABEL maintainer="Marco Lüthy <marco.luethy@gmail.com>"

LABEL chromium="${VERSION}"



WORKDIR /



ADD build.sh /

ADD .gclient /build/chromium/



RUN printf "LANG=en_US.utf-8\nLC_ALL=en_US.utf-8" >> /etc/environment

#RUN yum groupinstall -y "Development Tools"

RUN yum install -y \

  alsa-lib-devel atk-devel binutils bison bluez-libs-devel brlapi-devel \

  bzip2 bzip2-devel cairo-devel cmake cups-devel dbus-devel dbus-glib-devel \

  expat-devel fontconfig-devel freetype-devel gcc-c++ git glib2-devel glibc \

  gperf gtk3-devel htop httpd java-1.*.0-openjdk-devel libatomic libcap-devel \

  libffi-devel libgcc libgnome-keyring-devel libjpeg-devel libstdc++ libuuid-devel \

  libX11-devel libxkbcommon-x11-devel libXScrnSaver-devel libXtst-devel mercurial \

  mod_ssl ncurses-compat-libs nspr-devel nss-devel pam-devel pango-devel \

  pciutils-devel php php-cli pkgconfig pulseaudio-libs-devel python python3 \

  tar zlib zlib-devel



ENV VERSION="113.0.5672.177"

RUN sh /build.sh



EXPOSE 9222



ENTRYPOINT [ \

  "/bin/headless-chromium", \

  "--disable-dev-shm-usage", \

  "--disable-gpu", \

  "--no-sandbox", \

  "--hide-scrollbars", \

  "--remote-debugging-address=0.0.0.0", \

  "--remote-debugging-port=9222" \

  ]

