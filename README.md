 # github.com/tiredofit/docker-postgres

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-postgres?style=flat-square)](https://github.com/tiredofit/docker-postgres/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-postgres/main.yml?branch=15&style=flat-square)](https://github.com/tiredofit/docker-postgres/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/postgres.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postgres/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/postgres.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postgres/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker image for [PostgreSQL](https://postgres.org),A relational database.

Features:

- Customizable Super user account and password
- Multiple database and user creation
- Extension Support
- Replication (Main, Secondary, Snapshot) support
- Monitoring support via Zabbix Agent 2
- Customizable paths for logs, config, data

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Server Options](#server-options)
    - [Database Options](#database-options)
    - [Replication Options](#replication-options)
    - [Monitoring Options](#monitoring-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/postgres) and is the recommended method of installation.

```bash
docker pull tiredofit/postgres:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Version | Container OS | Tag       |
| ------- | ------------ | --------- |
| latest  | Alpine       | `:latest` |
| 15.x    | Alpine       | `:15`     |
| 14.x    | Alpine       | `:14`     |
| 13.x    | Alpine       | `:13`     |
| 12.x    | Alpine       | `:12`     |


#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory                          | Description                                             |
| ---------------------------------- | ------------------------------------------------------- |
| `/certs/`                          | (optional) Drop TLS Certificates here                   |
| `/var/lib/postgresql/data/conf.d/` | Supplemental Configuration directory, loaded at startup |
| `/var/lib/postgresql/data/`        | Configuration Directory                                 |
| `/var/lib/postgresql/data/`        | Databases                                               |
| `/logs/`                           | Logfiles                                                |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Container Options

| Parameter                    | Description                                                                                                                             | Default                     |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `CERT_PATH`                  | Certificates location                                                                                                                   | `/certs/`                   |
| `CONFIG_CUSTOM_PATH`         | Custom location for configuration                                                                                                       | `${CONFIG_PATH}/conf.d`     |
| `CONFIG_FILE`                | Configuration file                                                                                                                      | `postgresql.conf`           |
| `CONFIG_MODE`                | Configuration mode `DEFAULT` - To be used at a later release                                                                            | `DEFAULT`                   |
| `CONFIG_PATH`                | Configuration storage                                                                                                                   | `${DATA_PATH}`              |
| `DATA_PATH`                  | Database storage                                                                                                                        | `/var/lib/postgresql/data/` |
| `HBA_FILE`                   | Host based access file name                                                                                                             | `pg_hba.conf`               |
| `IDENT_FILE`                 | Identity file name                                                                                                                      | `pg_ident.conf`             |
| `LOG_FILE`                   | Logfile name                                                                                                                            | `postgresql.log`            |
| `LOG_FORMAT`                 | Log format `NORMAL` `JSON` or `CSV` Filename extension will change from `.log` to either `.json` or `.csv`                              | `NORMAL`                    |
| `LOG_LEVEL`                  | Log level messages                                                                                                                      | `WARNING`                   |
|                              | Values can be in descending detail `DEBUG5`,`DEBUG4`,`DEBUG3`,`DEBUG2`,`DEBUG1`,`INFO`,`NOTICE`,`WARNING`,`ERROR`,`LOG`,`FATAL`,`PANIC` |                             |
| `LOG_LEVEL_ERROR_STATEMENTS` | Log level for errors                                                                                                                    | `ERROR`                     |
| `LOG_PATH`                   | Store log files here                                                                                                                    | `/logs/`                    |
| `LOG_TYPE`                   | Log Type `CONSOLE` or `FILE`                                                                                                            | `FILE`                      |
| `SETUP_MODE`                 | `AUTO` generate configuration files based on env vars                                                                                   | `AUTO`                      |
| `WAL_PATH`                   | Write ahead log path if needing to be seperate from `DATA_PATH`                                                                         |                             |

#### Server Options

These options are related to overall server operations. Those bracketed with `(init)` cannot be changed after first run.

| Parameter               | Description                                      | Default    | `_FILE` |
| ----------------------- | ------------------------------------------------ | ---------- | ------- |
| `ENABLE_DATA_CHECKSUMS` | (init) Enable Data Checksumming                  | `FALSE`    |         |
| `INITDB_ARGS`           | Send arguments to initdb function                |            |         |
| `INITDB_ENCODING`       | (init) DB Encoding                               | `UTF-8`    |         |
| `INITDB_LC_COLLATE`     | (init) Locale Collation                          | `C`        |         |
| `INITDB_LC_CTYPE`       | (init) Locale CType                              | `C`        |         |
| `INITDB_LOCALE`         | (init) Locale                                    | `en`       |         |
| `LISTEN_IP`             | Listen Interface                                 | `*`        |         |
| `LISTEN_PORT`           | Listening Port                                   | `5432`     |         |
| `MAX_CONNECTIONS`       | Maximum concurrent connections to accept         | `100`      |         |
| `SERVER_ARGS`           | Send arguments to main Postgresql server process |            |         |
| `SUPERUSER_PASS`        | Password for `postgres` super user account       | ``         | x       |
| `SUPERUSER_USER`        | Name of super user account                       | `postgres` | x       |
| `WAL_SEGMENT_SIZE_MB`   | (init) Write ahead log segment size in MB        | `16`       |         |


#### Database Options

Automatically create user databases on startup. This can be done on each container start, and then removed on subsequent starts if desired.

| Parameter      | Description                                   | Default | `_FILE` |
| -------------- | --------------------------------------------- | ------- | ------- |
| `CREATE_DB`    | Automatically create databases on startup     | `TRUE`  | x       |
| `DB_NAME`      | Database Name e.g. `database`                 |         | x       |
| `DB_USER`      | Database User e.g. `user`                     |         | x       |
| `DB_PASS`      | Database Pass e.g. `password`                 |         | x       |
| `DB_EXTENSION` | (optional) Database Extension e.g. `unaccent` |         | x       |

**OR**

Create multiple databases and different usernames and passwords to access. You can share usernames and passwords for multiple databases by using the same user and password in each entry.

| Parameter                | Description                                        | Default | `_FILE` |
| ------------------------ | -------------------------------------------------- | ------- | ------- |
| `DB01_NAME`              | First Database Name e.g. `database1`               |         | x       |
| `DB01_USER`              | First Database User e.g. `user1`                   |         | x       |
| `DB01_PASS`              | First Database Pass e.g. `password1`               |         | x       |
| `DB01_EXTENSION`         | (optional) Database Extension e.g. `unaccent`      |         | x       |
| `DB02_NAME`              | Second Database Name e.g. `database1`              |         | x       |
| `DB02_USER`              | Second Database User e.g. `user2`                  |         | x       |
| `DB02_PASS`              | Second Database Pass e.g. `password2`              |         | x       |
| `DB02_EXTENSION`         | (optional) Database Extension e.g. `unaccent`      |         |         |
| `DBXX_...`               | As above, should be able to go all the way to `99` |         |         |

#### Replication Options

Enable replication from a `main` provider to a `secondary` read only node or a one time `snapshot` that can be used for read write later on.

| Parameter              | Description                                                 | Default     | `_FILE` |
| ---------------------- | ----------------------------------------------------------- | ----------- | ------- |
| `ENABLE_REPLICATION`   | Enable Replication Functionality                            | `FALSE`     |         |
| `REPLICATION_IP_ALLOW` | (main) Allow connections from this IP                       | `0.0.0.0/0` |         |
| `REPLICATION_MODE`     | Replication Mode `main`,`secondary`,`snapshot`              | `main`      |         |
| `REPLICATION_USER`     | (main/secondary/snapshot) Replication User                  | `replicate` | x       |
| `REPLICATION_HOST`     | (secondary/snapshot) Hostname of Replication Main server    |             | x       |
| `REPLICATION_PASS`     | (main/secondary/snapshot) Password of Replication User      |             | x       |
| `REPLICATION_PORT`     | (secondary/snapshot) Port number of Replication Main server | `5432`      | x       |
| `REPLICATION_TLS_MODE` | Replication TLS Mode                                        | `prefer`    |         |

#### Monitoring Options

- Zabbix Monitoring only at this time

| Parameter                     | Description                      | Default       | `FILE` |
| ----------------------------- | -------------------------------- | ------------- | ------ |
| `CONTAINER_ENABLE_MONITORING` | Enable Zabbix Agent 2 Monitoring | `TRUE`        |        |
| `MONITOR_USER`                | Monitoring User                  | `zbx_monitor` | x      |
| `MONITOR_PASS`                | Monitoring Password              | `zabbix`      | x      |

### Networking

The following ports are exposed.

| Port   | Description     |
| ------ | --------------- |
| `5432` | Postgres Server |

## Maintenance
Inside the image are tools to perform modification on how the image runs.

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.

### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support.

### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## References

* https://postgres.org


