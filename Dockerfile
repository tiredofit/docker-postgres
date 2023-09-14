ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.18"

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG POSTGRES_VERSION
ARG POSTGRES_ZABBIX_PLUGIN_VERSION
ENV POSTGRES_VERSION=${POSTGRES_VERSION:-"16.0"} \
    POSTGRES_ZABBIX_PLUGIN_VERSION=${POSTGRES_ZABBIX_PLUGIN_VERSION:-"6.4.6"} \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/postgres:15" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-postgres/"

RUN source /assets/functions/00-container && \
    set -ex && \
    addgroup -g 70 postgres && \
    adduser -S -D -H -h /var/lib/postgresql -s /bin/sh -G postgres -u 70 postgres && \
    mkdir -p /var/lib/postgresql && \
    chown -R postgres:postgres /var/lib/postgresql && \
    \
    package update && \
    package upgrade && \
    package install .postgres-build-deps \
                    bison \
                    clang15 \
                    coreutils \
                    dpkg-dev \
                    dpkg \
                    flex \
                    g++ \
                    gcc \
                    icu-dev \
                    libc-dev \
                    libedit-dev \
                    libxml2-dev \
                    libxslt-dev \
                    linux-headers \
                    llvm15-dev \
                    lz4-dev \
                    make \
                    openldap-dev \
                    openssl-dev \
                    perl-dev \
                    perl-ipc-run \
                    perl-utils \
                    python3-dev \
                    tcl-dev \
                    util-linux-dev \
                    zlib-dev \
                    zstd-dev \
                    && \
   \
   package install .postgres-run-deps \
                    icu-data-full \
                    libpq-dev \
                    llvm15 \
                    musl-locales \
                    openssl \
                    zstd-libs \
                    && \
   \
   package install .postgres-zabbix-plugin-build-deps \
                    go \
                    make \
                    && \
   \
   mkdir -p /usr/src/postgres-zabbix-plugin && \
   curl -sSL https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${POSTGRES_ZABBIX_PLUGIN_VERSION}.tar.gz | tar xvfz - --strip 2 -C /usr/src/postgres-zabbix-plugin && \
   cd /usr/src/postgres-zabbix-plugin && \
   make && \
   strip zabbix-agent2-plugin-postgresql && \
   mkdir -p /var/lib/zabbix/plugins && \
   cp zabbix-agent2-plugin-postgresql /var/lib/zabbix/plugins && \
   mkdir -p /usr/src/postgres && \
   curl -sSL https://ftp.postgresql.org/pub/source/v$POSTGRES_VERSION/postgresql-$POSTGRES_VERSION.tar.bz2 | tar xvfj - --strip 1 -C /usr/src/postgres && \
   cd /usr/src/postgres && \
   awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new && \
   grep '/var/run/postgresql' src/include/pg_config_manual.h.new && \
   mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h && \
   wget -O config/config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=7d3d27baf8107b630586c962c057e22149653deb' && \
   wget -O config/config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=7d3d27baf8107b630586c962c057e22149653deb' && \
   export LLVM_CONFIG="/usr/lib/llvm15/bin/llvm-config" && \
   export CLANG=clang-15  && \
   ./configure \
        --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix=/usr/local \
        --with-includes=/usr/local/include \
        --with-libraries=/usr/local/lib \
        --with-system-tzdata=/usr/share/zoneinfo \
        --with-pgport=5432 \
        --disable-rpath \
        --enable-integer-datetimes \
	--enable-thread-safety \
	--enable-tap-tests \
	--with-gnu-ld \
        --with-icu \
	--with-ldap \
	--with-libxml \
	--with-libxslt \
        --with-llvm \
	--with-lz4 \
	--with-openssl \
        --with-perl \
	--with-python \
	--with-tcl \
	--with-uuid=e2fs \
	--with-zstd \
        && \
    make -j "$(nproc)" world && \
    make install-world && \
    make -j "$(nproc)" -C contrib && \
    make -C contrib/ install && \
    runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
			| grep -v -e perl -e python -e tcl \
            )"; \
	package install .postgres-additional-deps \
                    $runDeps \
	                && \
	\
    package remove \
                    .postgres-build-deps \
                    .postgres-zabbix-plugin-build-deps \
                    && \
    package cleanup && \
    find /usr/local -name '*.a' -delete && \
    rm -rf \
            /root/.cache \
            /root/go \
	        /usr/local/share/doc \
	        /usr/local/share/man \
            /usr/src/*

EXPOSE 5432
COPY install /
