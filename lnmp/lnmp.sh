#!/bin/sh

if [ `whoami` != 'root' ]; then
    echo "Need to be root."
    exit 1
fi

# install requested yum utils
yum install yum-utils yum-plugin-priorities epel-release redhat-lsb-core -y

VERSION=`lsb_release -r | awk '{print $2}' | awk 'BEGIN { FS = "." }; {print $1}'`

yum install http://rpms.famillecollet.com/enterprise/remi-release-${VERSION}.rpm -y

yum-config-manager --enable remi remi-php56 epel
yum-config-manager --setopt='remi.priority=1' --save remi
yum-config-manager --setopt='remi-php56.priority=1' --save remi-php56
yum-config-manager --setopt='epel.priority=10' --save epel

yum update -y

yum install php-fpm php-mysql php-gd php-imap php-ldap php-odbc php-pear \
php-xml php-xmlrpc php-pecl-apc php-mcrypt php-mbstring -y

yum install mariadb mariadb-server -y

# setting owners and groups
sed -i "s/apache/nginx/g" /etc/php-fpm.d/www.conf

# basic security setting in php.ini
sed -i "s/expose_php = On/expose_php = Off/g" /etc/php.ini

# start php, mysql and nginx at boot
if [ $VERSION -eq 7 ]; then
    systemctl enable mariadb
    systemctl start mariadb
    systemctl enable php-fpm
    systemctl start php-fpm
    systemctl enable nginx
    systemctl start nginx
elif [ $VERSION -eq 6 ]; then
    service mariadb start
    service php-fpm start
    service nginx start
    chkconfig --level 345 mariadb on
    chkconfig --level 345 php-fpm on
    chkconfig --level 345 nginx on
fi

# Manual step, change mysql root password.
mysql_secure_installation
