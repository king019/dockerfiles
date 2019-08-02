#include "common.Dockerfile"
#include "image/multiarch_debian_buster.Dockerfile"
#include "env.Dockerfile"

#if defined(ARCH_ARM32V7) || defined(ARCH_ARM64V8)
#error "OpenLitespeed does not support ARM"
#endif

ENV LIBONIG2_VERSION="5.9.5-3.2+deb8u1"
RUN sh -c "echo \"deb http://rpms.litespeedtech.com/debian/ jessie main\" > /etc/apt/sources.list.d/lst_debian_repo.list" \
    && sh -c "echo \"deb http://rpms.litespeedtech.com/debian/ stretch main\" >> /etc/apt/sources.list.d/lst_debian_repo.list" \
    && wget -O /etc/apt/trusted.gpg.d/lst_debian_repo.gpg http://rpms.litespeedtech.com/debian/lst_debian_repo.gpg \
    && wget -O /etc/apt/trusted.gpg.d/lst_repo.gpg http://rpms.litespeedtech.com/debian/lst_repo.gpg \
    && cd /tmp \
      && wget http://ftp.debian.org/debian/pool/main/libo/libonig/libonig2_${LIBONIG2_VERSION}_${THIS_ARCH_ALT}.deb \
      && dpkg -i libonig2_${LIBONIG2_VERSION}_${THIS_ARCH_ALT}.deb \
      && rm libonig2_${LIBONIG2_VERSION}_${THIS_ARCH_ALT}.deb \
      && cd / \
    && PKG_INSTALL(openlitespeed ols-pagespeed ols-modsecurity) \
    && sh -c "apt-cache search lsphp | cut -f1 -d' ' | egrep -v \"(dbg|dev|source)\" | xargs apt-get install -y" \
    && ln -sf /usr/local/lsws/lsphp53/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp53 \
    && ln -sf /usr/local/lsws/lsphp54/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp54 \
    && ln -sf /usr/local/lsws/lsphp55/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp55 \
    && ln -sf /usr/local/lsws/lsphp56/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp56 \
    && ln -sf /usr/local/lsws/lsphp56/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5 \
    && ln -sf /usr/local/lsws/lsphp70/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp70 \
    && ln -sf /usr/local/lsws/lsphp71/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp71 \
    && ln -sf /usr/local/lsws/lsphp72/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp72 \
    && ln -sf /usr/local/lsws/lsphp73/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp73 \
    && ln -sf /usr/local/lsws/lsphp73/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp7 \
    && ln -sf /usr/local/lsws/lsphp73/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp \
    && rm -rf /var/cache/apt
ENTRYPOINT ["sh", "-c", "/usr/local/lsws/bin/lswsctrl start; tail -f /usr/local/lsws/logs/error.log"]