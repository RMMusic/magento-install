Hi everyone,
This repository contain script that installs 

PHP 7.0
NGINX
MySQL
Magento 2 with Sample data

tested on Ubuntu 14.04.4 LTS

# Usage

First you need to clone this repo:
```
$ git clone git@github.com:UrkoBanzay/magento-install.git
$ cd magento-install/
```
for a successful script run you need add all this arguments to script-run command:

homedir - home directory for magento

domainname - domain name

dbrootpass - mysql root user pass

dbname - name for mysql database, it also name for user

dbpass - pass for above asignet user

adminlog - magento admin panel login name

adminpass - magento admin panel password

  arguments lists with a space between each other
the correct order is important, example :
```
$ sudo bash magento-script.sh /var/www/ magento2.com mysqlroot_pass magentodbname magentodbpass adminloginname adminpass
```
script also use repo.magento.com repository, where Magento 2 and third-party component Composer packages are stored, requires authentication. So you can create "auth.json" file in directory with all script files and paste your keys in file, like that:
```
{
    "http-basic": {
        "repo.magento.com": {
            "username": "Your Public key",
            "password": "Your Private key "
        }
    }
}
```
if you run script with no auth.json file in script directory then you need to paste your keys in command line mannualy when they needed.

More about this repository and authentication - (http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html)
