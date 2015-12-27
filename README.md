# AMP-Stack for Vagrant

Usage:

```
# There's no VirtualBox Guest Addition installed, let's do that by a plugin
vagrant plugin install vagrant-vbguest
# Now load and start the image
vagrant init chrisandchris/amp && vagrant up
```

See: https://atlas.hashicorp.com/chrisandchris/boxes/amp

## Specification
This small repo is an AMP-Stack for Vagrant, with the following specification:

- Apache 2.4
- PHP from *ppa:ondrej/php5-5.6* with extensions
    - CURL, GD, MCRYPT, MySQL, xDebug
    - extensive error reporting
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
- Git
- NodeJS
- Gulp

## How to improve
1. Make changes to source
2. Change version in `template.json` for each provider image
3. Push with `git push`
4. Push with `packer push -name chrisandchris/amp template.json` 
