#!/bin/bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/home/
php -r "unlink('composer-setup.php');"
cd /home/.composer/
touch auth.json
echo "
{
    "http-basic": {
        "repo.magento.com": {
            "username": "b1578765b9b29d21c79478d68803dae6",
            "password": "de1733b496f55dad1b05cb04d26c9ab1"
        }
    }
}

" > /home/.composer/auth.json