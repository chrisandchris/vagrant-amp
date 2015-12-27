# AMP-Stack for Vagrant
This small repo is an AMP-Stack for Vagrant, with the following specification:

- Apache 2.2
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
