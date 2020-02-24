#include "common.Dockerfile"
#include "image/debian_buster.Dockerfile"
#include "env.Dockerfile"

#define APP_DEPS tini libncurses6 libncursesw6 libreadline7
#define APP_BUILD_TOOLS build-essential bison flex libncurses-dev libreadline-dev LINUX_HEADERS wget patch binutils

ENV BIRD_VERSION=2.0.7 DNSMASQ_VERSION=2.80
ADD start.sh /start.sh
RUN PKG_INSTALL(APP_DEPS APP_BUILD_TOOLS) \
    && chmod +x /start.sh \
    && cd /tmp \
    && UNTARGZ(ftp://bird.network.cz/pub/bird/bird-${BIRD_VERSION}.tar.gz) \
       && cd /tmp/bird-${BIRD_VERSION} \
       && ./configure --prefix=/usr \
          --sysconfdir=/etc \
          --mandir=/usr/share/man \
          --localstatedir=/var \
       && make -j4 && make install \
       && strip /usr/sbin/bird* \
    && cd /tmp \
    && UNTARGZ(http://www.thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.xz) \
       && cd /tmp/dnsmasq-${DNSMASQ_VERSION} \
       && make -j4 && make install \
       && strip /usr/local/sbin/* \
    && cd / \
    && rm -rf /tmp/* \
    && rm -rf /usr/share/man /usr/local/share/man \
    && PKG_UNINSTALL(APP_BUILD_TOOLS)
ADD bird.conf /etc/bird.conf
ADD bird-static.conf /etc/bird-static.conf
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/start.sh"]