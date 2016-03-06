# AMP-Stack for Vagrant

##  Usage

```
# There's no VirtualBox Guest Addition installed, let's do that by a plugin
vagrant plugin install vagrant-vbguest
# Now load and start the image for PHP5.6 stack
vagrant init chrisandchris/amp && vagrant up
# Use the PHP7 stack
vagrant init chrisandchris/amp7 && vagrant up
```

See: https://atlas.hashicorp.com/chrisandchris/boxes/amp
And: https://atlas.hashicorp.com/chrisandchris/boxes/amp7

## Developers note
If you have any input, any issue or whatever, do not hesitate to write me.

## Specification
This small repo is an AMP-Stack for Vagrant, with the following specification:

- Apache 2.4
- PHP from *ppa:ondrej/php5-5.6* with extensions
    - CURL, GD, MCRYPT, MySQL, xDebug
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
- PostgreSQL 9.4 with default configuration
- Git
- NodeJS
- Gulp

# Changelog
## Amp7
### v1.0.3
- split deps up in before, custom, after
- fixed small issues in scripts
- fixed issues from v1.0.2

### v1.0.2
- has been revoked

### 1.0.1
- xDebug: Disabled profiler by default

## Amp5.6
### v1.0.7
- split deps up in before, custom, after
- fixed issue with wrong php version in 1.0.6 (now has 5.6.x)

### v1.0.6
- fixed issues from v1.0.5

### v1.0.5
- has been revoked

### 1.0.4
- xDebug: Disabled profiler by default

## How to improve
1. Make changes to source
2. Change version in `template.json` for each provider image
3. Push with `git push`
4. Push with `packer push -name chrisandchris/amp template.json`
