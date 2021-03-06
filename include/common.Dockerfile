#define WGET(url) wget --no-check-certificate -q url
#define PATCH(url) WGET(url) -O- | patch -p1
#define PATCH_LOCAL(path) cat path | patch -p1
#define UNTARGZ(url) WGET(url) -O download.tar.gz \
    && tar xf download.tar.gz && rm download.tar.gz
#define EMPTY(folder) find folder -mindepth 1 -delete
#define FINAL_CLEANUP() PKG_CLEANUP() \
    && EMPTY(/root) \
    && EMPTY(/tmp) \
    && rm -rf /usr/local/share/doc \
    && rm -rf /usr/local/share/man \
    && rm -rf /usr/share/doc \
    && rm -rf /usr/share/man \
    && EMPTY(/var/cache) \
    && EMPTY(/var/log)
