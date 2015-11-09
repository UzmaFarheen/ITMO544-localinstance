#!/bin/bash

sudo apt-get -y update
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl

curl -sS https://getcomposer.org/installer | php

php composer.phar require aws/aws-sdk-php

mv ./ITMO-547/html.html /var/www/html
 
echo"Hello, My Name is UZMA FARHEEN" > /tmp/hello.txt
