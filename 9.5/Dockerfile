FROM tiredofit/alpine:3.5
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

	ENV LANG=en_US.utf8 \
	    PG_MAJOR=9.5 \
	    PG_VERSION=9.5.8 \
	    PG_SHA256=ade57068f134f36710fa953e1ef79185abd96572f8098741413132f79ed37202 \
	    PATH=/usr/lib/postgresql/$PG_MAJOR/bin:$PATH \
	    PGDATA=/var/lib/postgresql/data \
	    ZABBIX_HOSTNAME=postgres-db

	RUN set -ex && \
		postgresHome="$(getent passwd postgres)" && \
		postgresHome="$(echo "$postgresHome" | cut -d: -f6)" && \
		[ "$postgresHome" = '/var/lib/postgresql' ] && \
		mkdir -p "$postgresHome" && \
		chown -R postgres:postgres "$postgresHome" && \

	    mkdir /docker-initdb.d && \

	    set -ex && \
		
		apk add --no-cache --virtual .fetch-deps \
			ca-certificates \
			openssl \
			tar \
		    && \
	
		wget -O postgresql.tar.bz2 "https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.bz2" && \
		echo "$PG_SHA256 *postgresql.tar.bz2" | sha256sum -c - && \
		mkdir -p /usr/src/postgresql && \
		tar --extract --file postgresql.tar.bz2 --directory /usr/src/postgresql --strip-components 1 && \
		rm postgresql.tar.bz2 && \
		
		apk add --no-cache --virtual .build-deps \
			bison \
			coreutils \
			dpkg-dev dpkg \
			flex \
			gcc \
	#		krb5-dev \
			libc-dev \
			libedit-dev \
			libxml2-dev \
			libxslt-dev \
			make \
	#		openldap-dev \
			openssl-dev \
			perl \
	#		perl-dev \
	#		python-dev \
	#		python3-dev \
	#		tcl-dev \
			util-linux-dev \
			zlib-dev \
		    && \

		cd /usr/src/postgresql && \
		awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new && \
		grep '/var/run/postgresql' src/include/pg_config_manual.h.new && \
		mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h && \
		gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	
	# explicitly update autoconf config.guess and config.sub so they support more arches/libcs
		wget -O config/config.guess "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" && \
		wget -O config/config.sub "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" && \
	
	# configure options taken from:
	# https://anonscm.debian.org/cgit/pkg-postgresql/postgresql.git/tree/debian/rules?h=9.5
		./configure \
			--build="$gnuArch" \
	# "/usr/src/postgresql/src/backend/access/common/tupconvert.c:105: undefined reference to `libintl_gettext'"
	#		--enable-nls \
			--enable-integer-datetimes \
			--enable-thread-safety \
			--enable-tap-tests \
	# skip debugging info -- we want tiny size instead
	#		--enable-debug \
			--disable-rpath \
			--with-uuid=e2fs \
			--with-gnu-ld \
			--with-pgport=5432 \
			--with-system-tzdata=/usr/share/zoneinfo \
			--prefix=/usr/local \
			--with-includes=/usr/local/include \
			--with-libraries=/usr/local/lib \
			\
	# these make our image abnormally large (at least 100MB larger), which seems uncouth for an "Alpine" (ie, "small") variant :)
	#		--with-krb5 \
	#		--with-gssapi \
	#		--with-ldap \
	#		--with-tcl \
	#		--with-perl \
	#		--with-python \
	#		--with-pam \
			--with-openssl \
			--with-libxml \
			--with-libxslt && \
	
		make -j "$(nproc)" world && \
		make install-world && \
		make -C contrib install && \
		
		runDeps="$( \
			scanelf --needed --nobanner --recursive /usr/local \
				| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
				| sort -u \
				| xargs -r apk info --installed \
				| sort -u \
		)" && \
		
		apk add --no-cache --virtual .postgresql-rundeps \
			$runDeps \
			su-exec \
			&& \
	
	# Cleanup
		apk del .fetch-deps .build-deps && \
		cd / && \
		rm -rf \
			/usr/src/postgresql \
			/usr/local/share/doc \
			/usr/local/share/man \ 
			rm -rf /var/cache/apk/* \
			&& \
		find /usr/local -name '*.a' -delete && \

	# make the sample config easier to munge (and "correct by default")
	    sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf.sample && \

## PostGres Setup Functions
	    mkdir -p /var/run/postgresql && \
	    chown -R postgres:postgres /var/run/postgresql && \
	    chmod g+s /var/run/postgresql && \
	    mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)

## Files Setup
   ADD /install /

## Networking
   EXPOSE 5432

## Entrypoint Configuration
   CMD ["/init"]

