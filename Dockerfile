FROM docker.io/tiredofit/alpine:3.16

ENV ZABBIX_AGENT_TYPE=CLASSIC \
    LANG=en_US.utf8 \
    PG_MAJOR=13 \
    PG_VERSION=13.7 \
    PGDATA=/var/lib/postgresql/data \
    IMAGE_NAME="tiredofit/postgres" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-postgres/"

### Create User Accounts
RUN set -ex && \
    addgroup -g 70 postgres && \
    adduser -S -D -H -h /var/lib/postgresql -s /bin/sh -G postgres -u 70 postgres && \
    mkdir -p /var/lib/postgresql && \
    chown -R postgres:postgres /var/lib/postgresql && \
    \
### Install Dependencies
   apk update && \
   apk upgrade && \
   apk add -t .postgres-run-deps \
       openssl \
       && \
   \
   apk add --no-cache --virtual .postgres-build-deps \
	   bison \
	   build-base \
	   coreutils \
	   dpkg-dev \
	   dpkg \
	   flex \
	   gcc \
	   icu-dev \
	   libc-dev \
   	   libedit-dev \
	   libxml2-dev \
	   libxslt-dev \
	   linux-headers \
	   make \
	   openssl-dev \
	   perl-utils \
	   perl-ipc-run \
	   util-linux-dev \
	   zlib-dev \
       && \
   \
### Build Postgresql
   mkdir -p /usr/src/postgresql && \
   curl -sSL "https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.bz2" | tar xvfj - --strip 1 -C /usr/src/postgresql && \
   cd /usr/src/postgresql && \
   awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new && \
   grep '/var/run/postgresql' src/include/pg_config_manual.h.new && \
   mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h && \
   gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
   wget -O config/config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=7d3d27baf8107b630586c962c057e22149653deb' && \
   wget -O config/config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=7d3d27baf8107b630586c962c057e22149653deb' && \
   ./configure \
		--build="$gnuArch" \
		--enable-integer-datetimes \
		--enable-thread-safety \
		--enable-tap-tests \
		--disable-rpath \
		--with-uuid=e2fs \
		--with-gnu-ld \
		--with-pgport=5432 \
		--with-system-tzdata=/usr/share/zoneinfo \
		--prefix=/usr/local \
		--with-includes=/usr/local/include \
		--with-libraries=/usr/local/lib \
		--with-openssl \
		--with-libxml \
		--with-libxslt \
		--with-icu \
	&& \
    \
    make -j "$(nproc)" world && \
    make install-world && \
    make -C contrib install && \
    runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" && \
	apk add -t .postgres-additional-deps \
	           $runDeps \
	           && \
	\
	sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf.sample && \
	mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql && \
	mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values) && \
    \
### Cleanup
    apk del .postgres-build-deps && \
    cd / && \
    rm -rf \
	/usr/src/postgresql \
	/usr/local/share/doc \
	/usr/local/share/man && \
    find /usr/local -name '*.a' -delete && \
    rm -rf /var/cache/apk/*

### Networking Configuration
   EXPOSE 5432

### Files Add 
   ADD install /

