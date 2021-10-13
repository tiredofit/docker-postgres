 # github.com/tiredofit/docker-postgres

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-postgres?style=flat-square)](https://github.com/tiredofit/docker-postgres/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-postgres/build?style=flat-square)](https://github.com/tiredofit/docker-postgres/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/postgres.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postgres/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/postgres.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postgres/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker image for [PostgreSQL](https://postgres.org) server. A relational database.
It has the same configuration variables as the Official [Postgres Image](https://github.com/docker-library/postgres)

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Installation](#installation-1)
  - [Build from Source](#build-from-source-1)
  - [Prebuilt Images](#prebuilt-images-1)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
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
```

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.## Installation

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
| 13.x    | Alpine       | `:13`     |
| 12.x    | Alpine       | `:12`     |
```

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.
```
| Directory                  | Description             |
| -------------------------- | ----------------------- |
| `/var/lib/postgresql/data` | Postgres Data Directory |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

| Parameter                 | Description                                                                 | Default                    |
| ------------------------- | --------------------------------------------------------------------------- | -------------------------- |
| `PG_DATA`                 | Location for Data Storage                                                   | `/var/lib/postgresql/data` |
| `POSTGRES_DB`             | Optional - Automatically Create Database (e.g. database)                    |                            |
| `POSTGRES_USER`           | Optional - Automatically Assign Username Priveleges to Database (e.g. user) |                            |
| `POSTGRES_PASSWORD`       | Password for authentication to above database (e.g. userpassword)           |                            |
| `POSTGRES_INITDB_ARGS`    | Send arguments to postgres-initdb (e.g. `--data-checksums`)                 |                            |
| `POSTGRES_INITDB_XLOGDIR` | Optional Log Location                                                       | `/var/lib/postgresql/data` |

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
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
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


