## 15-3.2.7 2023-11-15 <dave at tiredofit dot ca>

   ### Changed
      - Fix issue with INITDB_LOCALE not being applied on database initialization
      - Fix image version reporting duplicate versions


## 15-3.2.6 2023-11-09 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 15.5
      - Zabbix Postgresql plugin 6.4.8


## 15-3.2.5 2023-08-14 <dave at tiredofit dot ca>

   ### Added
      - Postgres 15.4


## 15-3.2.4 2023-07-15 <dave at tiredofit dot ca>

   ### Added
      - Zabbix Agent 6.4.4
      - Reintroduce building with Clang 15


## 15-3.2.2 2023-06-19 <dave at tiredofit dot ca>

   ### Changed
      - Fix Zabbix Agent2 compilation resulting in breaking rest of build
      - Strip debug symbols from Zabbix Agent 2


## 15-3.2.1 2023-06-16 <dave at tiredofit dot ca>

   ### Reverted
      - Stop including llvm dependencies


## 15-3.2.0 2023-05-10 <dave at tiredofit dot ca>

   ### Added
      - PostgreSQL 15.3
      - Alpine 3.18 base


## 15-3.1.1 2023-05-09 <dave at tiredofit dot ca>

   ### Added
      - Update Zabbix Postgresql Plugin to 6.4.2


## 15-3.1.0 2023-04-26 <dave at tiredofit dot ca>

   ### Added
      - Add support for _FILE environment variables


## 15-3.0.2 2023-02-08 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 15.2
      - Zabbix Postgresql plugin 6.2.7


## 3.0.1 2023-01-04 <dave at tiredofit dot ca>

   ### Changed
      - Build and insert Zabbix Agent 2 Postgresql plugin in this image
      - Cleanup build directories for smaller image size


## 3.0.0 2022-12-31 <dave at tiredofit dot ca>

This image rewrite contains many breaking changes, yet tries to keep compatibility with older installations specifically with paths. It would be recommended to take a backup of your existing database and restore to a fresh installation to take advantage of the new features.

   ### Added
      - Rewrote entire image
      - Independent Superuser User and Password for controlling all aspects of server
      - Multiple Database and User support
      - Extensions Support per database
      - Replication Support (Main, Secondary (Read Only), Snapshot)
      - Customizable paths for logs, config, data, seperate path for transaction logs
      - Log formatting, Log type options
      - Customizable Locales
      - Monitoring Support using Zabbix 2 Agent
      - Customizable Listening Ports

   ### Reverted
      - Deprecation of POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB environment variables. See README for information


## 2.5.12 2022-11-23 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.17 base


## 2.5.11 2022-11-18 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 15.1


## 2.5.10 2022-10-13 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 15.0


## 2.5.9 2022-09-14 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.5


## 2.5.8 2022-06-09 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.4


## 2.5.7 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.16 base


## 2.5.6 2022-05-15 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.3


## 2.5.5 2022-03-14 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.2


## 2.5.4 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Rework to support new base image


## 2.5.3 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Update base image


## 2.5.2 2021-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add Zabbix Auto Agent registration support for templates


## 2.5.1 2021-12-01 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.1


## 2.5.0 2021-10-13 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 14.0


## 2.4.5 2021-09-17 <dave at tiredofit dot ca>

   ### Added
      - Pin Zabbix Agent Classic


## 2.4.4 2021-08-18 <dave at tiredofit dot ca>

   ### Added
      - Postgres 13.4


## 2.4.3 2021-07-26 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.14
      - Postgresql 13.3


## 2.4.2 2021-05-09 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup of Docker image


## 2.4.1 2021-03-10 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 13.2


## 2.4.0 2020-11-14 <dave at tiredofit dot ca>

   ### Added
      - Postgres 13.1

## 2.3.1 2020-09-12 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.12
      - Postgres 12.4


## 2.3.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.0.0 base image


## 2.2.3 2020-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Move /etc/s6/services to /etc/services.d


## 2.2.2 2020-05-20 <dave at tiredofit dot ca>

   ### Added
      - Postgres 12.3


## 2.2.1 2020-02-15 <dave at tiredofit dot ca>

   ### Added
      - Postgres 12.2


## 2.2.0 2020-01-02 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 2.1.16 2019-12-20 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.11 Base Image


## 2.1.15 2019-11-25 <dave at tiredofit dot ca>

   ### Added
      - Postgresql 12.1


## 2.1.14 2019-11-04 <dave at tiredofit dot ca>

* Bugfix

## 2.1.13 2019-11-04 <dave at tiredofit dot ca>

* Postgres 12.0

## 2.1.12 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.5

## 2.1.11 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.4

## 2.1.10 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.3

## 2.1.9 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.2

## 2.1.8 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.1

## 2.1.7 2019-11-04 <dave at tiredofit dot ca>

* Postgres 11.0

## 2.1.6 2019-11-04 <dave at tiredofit dot ca>

* Postgres 10.10

## 2.1.5 2019-11-04 <dave at tiredofit dot ca>

* Postgres 10.9

## 2.1.4 2019-11-04 <dave at tiredofit dot ca>

* Postgres 10.8

## 2.1.3 2019-11-04 <dave at tiredofit dot ca>

* Postgres 10.7

## 2.1.2 2018-12-10 <dave at tiredofit dot ca>

* Postgres 10.6

## 2.1.1 2018-09-26 <dave at tiredofit dot ca>

* Postgres 10.5

## 2.1 2018-01-31 <dave at tiredofit dot ca>

* Update to Alpine 3.7
* Update Postgres 9.5.10
* Fix Zabbix Checks

## 2.0 2017-10-27 <dave at tiredofit dot ca>

* Update to Postgres 10

## 2.0 2017-08-28 <dave at tiredofit dot ca>

* Rebase with s6 overlay
* Postgres 9.5.8

## 1.0 2017-05-14 <dave at tiredofit dot ca>

* Initial Release
* Postgres 9.5.6
* Zabbix Enabled
* Alpine 3.5

