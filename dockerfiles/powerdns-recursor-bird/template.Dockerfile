#include "common.Dockerfile"
#include "image/debian_buster.Dockerfile"
#include "env.Dockerfile"

#define APP_DEPS tini pdns-recursor pdns-tools pdns-backend-\*
#define APP_BUILD_TOOLS build-essential bison flex libncurses-dev libreadline-dev linux-headers-${THIS_ARCH_ALT} wget patch binutils

ENV BIRD_VERSION=2.0.5
RUN PKG_INSTALL(APP_DEPS APP_BUILD_TOOLS) \
    && rm -rf /var/cache/apk/* \
    && chmod +x /start.sh \
    && cd /tmp \
    && UNTARGZ(ftp://bird.network.cz/pub/bird/bird-${BIRD_VERSION}.tar.gz) \
    && cd /tmp/bird-${BIRD_VERSION} \
    && ./configure --prefix=/usr \
	   --sysconfdir=/etc \
	   --mandir=/usr/share/man \
	   --localstatedir=/var \
    && make && make install \
    && rm -rf /usr/share/man \
    && rm -rf /tmp/* \
    && strip /usr/sbin/bird* \
    && PKG_UNINSTALL(APP_BUILD_TOOLS)
ADD start.sh /start.sh
ADD bird.conf /etc/bird.conf
ADD bird-static.conf /etc/bird-static.conf
ENTRYPOINT ["/sbin/tini", "-g", "--", "/start.sh"]