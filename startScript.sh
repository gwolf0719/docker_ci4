#!/bin/bash
/usr/sbin/apache2ctl -D FOREGROUND

# composer create-project codeigniter4/appstarter ./tempfile
# chmod -R 0777 /var/www/html/tempfile/writable
# mv tempfile/* ./ 
# mv tempfile/.gitignore ./.gitignore

# # cd /var/www/html
# composer create-project codeigniter4/appstarter ./
# chmod -R 0777 /var/www/html/writable
# composer update
# git pull
# php spark migrate