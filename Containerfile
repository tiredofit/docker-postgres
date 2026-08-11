# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Postgresql" \
        org.opencontainers.image.description="Relational database" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/postgres" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-postgres/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-postgres.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    POSTGRES_VERSION="REL_16_15" \
    POSTGRES_REPO_URL="https://github.com/postgres/postgres" \
    POSTGRES_ZABBIX_PLUGIN_VERSION

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    IMAGE_NAME="nfrastack/postgres" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-postgres/"

EXPOSE 5432

RUN echo "" && \
    POSTGRES_BUILD_DEPS_ALPINE=" \
                                    bison \
                                    clang20 \
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
                                    llvm20-dev \
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
                                " \
                                && \
    \
    POSTGRES_ZABBIX_BUILD_DEPS_ALPINE=" \
                                        make \
                                    " \
                                    && \
    \
    POSTGRES_RUN_DEPS_ALPINE=" \
                                icu-data-full \
                                icu-libs \
                                libldap \
                                libpq \
                                llvm20 \
                                lz4-libs \
                                musl-locales \
                                openssl \
                                zstd-libs \
                            " \
                            && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user postgres 70 postgres 70 /var/lib/postgresql && \
    package update && \
    package upgrade && \
    package install \
                        POSTGRES_BUILD_DEPS \
                        POSTGRES_RUN_DEPS \
                    && \
    \
    if [ -f "/usr/local/bin/zabbix_agent2" ]; then \
        package install \
                        POSTGRES_ZABBIX_BUILD_DEPS \
                        && \
        package build go buildtime && \
        POSTGRES_ZABBIX_PLUGIN_VERSION=${POSTGRES_ZABBIX_PLUGIN_VERSION:-"$(zabbix_agent2 --version | head -n1 | awk {'print $3'})"} ; \
        mkdir -p /usr/src/postgres-zabbix-plugin ; \
        curl -sSL https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${POSTGRES_ZABBIX_PLUGIN_VERSION}.tar.gz | tar xvfz - --strip 2 -C /usr/src/postgres-zabbix-plugin ; \
        cd /usr/src/postgres-zabbix-plugin ; \
        make ; \
        strip zabbix-agent2-plugin-postgresql ; \
        mkdir -p /var/lib/zabbix/plugins ; \
        cp zabbix-agent2-plugin-postgresql /var/lib/zabbix/plugins ; \
        container_build_log add "Postgres Zabbix Plugin" "${POSTGRES_ZABBIX_PLUGIN_VERSION}" "zabbix.com" ; \
    fi ; \
    clone_git_repo "${POSTGRES_REPO_URL}" "${POSTGRES_VERSION}" && \
    awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new && \
    grep '/var/run/postgresql' src/include/pg_config_manual.h.new && \
    mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h && \
    wget -O config/config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=7d3d27baf8107b630586c962c057e22149653deb' && \
    wget -O config/config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=7d3d27baf8107b630586c962c057e22149653deb' && \
    export LLVM_CONFIG="/usr/lib/llvm20/bin/llvm-config" && \
    export CLANG=clang-20 && \
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
    make -j "$(nproc)" world-bin && \
    make install-world-bin && \
    make -j "$(nproc)" -C contrib && \
    make -C contrib/ install && \
    package install SCANNED_RUNTIME_DEPS && \
    container_build_log add "Postgresql" "$(echo ${POSTGRES_VERSION#REL_} | tr '_' '.')" "${POSTGRES_REPO_URL}" && \
    rm -rf \
	        /usr/local/share/doc \
	        /usr/local/share/man \
            && \
    package remove \
                    POSTGRES_BUILD_DEPS \
                    POSTGRES_ZABBIX_BUILD_DEPS \
                    && \
    package cleanup

COPY rootfs /
