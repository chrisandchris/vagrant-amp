# AMPP-Stack for Vagrant
A nice *Apache, MySQL, PHP, PgSQL*-Stack for Vagrant. Pretty good variety of modules and tools that are pre-installed. Backups your databases (mysql) up on shutdown. Has Git, NodeJS, NPM, Gulp installed and configured. Provides an SSL-VirtualHost for Apache using an automated generated self-signed cert.

Misses nothing, it's your fully-featured dev environment ready in a sec.

##  Usage

We support *libvirt* and *virtualbox* as provider!

```
# There's a vvguest installed, but make sure it matches your installation
vagrant plugin install vagrant-vbguest
# Now load and start the image for PHP5.6 stack
vagrant init chrisandchris/amp && vagrant up
# Use the PHP7 stack
vagrant init chrisandchris/amp7 && vagrant up
```

See: https://atlas.hashicorp.com/chrisandchris/boxes/amp and https://atlas.hashicorp.com/chrisandchris/boxes/amp7

## Specification
The boxes consist of:

- Apache 2.4
    - using a self-signed certificate for ssl connections (generated on boot if not yet done)
- PHP from *ppa:ondrej/php5-5.6* with extensions
    - CURL, GD, MCRYPT, MySQL, xDebug, mbstring, PDO
    - extensive error reporting
- *or* PHP 7 when using the *amp7* stack
- xDebug is pre-configured
- Some Alias-Commands:
    - phpx for php with xDebug in CLI
    - phpunitx for phpunit with xDebug in CLI
- MySQL 5.5
    - in **strict** mode
        - NO_ZERO_IN_DATE
        - NO_ZERO_DATE
        - ONLY_FULL_GROUP_BY
        - STRICT_ALL_TABLES
    - every database gets automatically backuped into .sql/ directory on `vagrant halt`
        - nice feature for developing wordpress/cms content offline
        - could prevent you from data loss
- PostgreSQL 9.4 with default configuration
- Git
- NodeJS
- Gulp

## How to improve
Submit an issue or a pull request!
