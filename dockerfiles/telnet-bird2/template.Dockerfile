#include "common.Dockerfile"
#include "image/debian_sid.Dockerfile"
#include "env.Dockerfile"

ADD bird-restricted.sh /usr/sbin/
RUN PKG_INSTALL(bird2 busybox-static) \
    && chmod +x /usr/sbin/bird-restricted.sh \
    && FINAL_CLEANUP()

STOPSIGNAL SIGKILL
ENTRYPOINT ["/bin/busybox", "telnetd", "-l", "/usr/sbin/bird-restricted.sh", "-K", "-F"]