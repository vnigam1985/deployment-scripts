#!/bin/sh
# remember to enable (default disabled) rememberlogin in your apps.
if [ -z $1 ]; then
    echo "Please give the version number"
    exit 1
fi

LOCATION=$(cd `dirname $0`; pwd)

cd $LOCATION

wget https://download.owncloud.org/community/owncloud-${1}.tar.bz2

tar xvjf owncloud-${1}.tar.bz2
mv owncloud oc-$1
cp oc-latest/config/config.php oc-$1/config/config.php
chown -R nginx:nginx oc-$1

# sed some strings
DEFAULT_FILE=$LOCATION/oc-${1}/lib/private/defaults.php
sed -i "s/defaultEntity = 'ownCloud'/defaultEntity = 'ChangeME'/g" $DEFAULT_FILE
sed -i "s/defaultName = 'ownCloud'/defaultName = 'CM'/g" $DEFAULT_FILE
sed -i "s/defaultTitle = 'ownCloud'/defaultTitle = 'ChangeMe'/g" $DEFAULT_FILE
sed -i "s/https:\/\/owncloud.org'/https:\/\/ChangeMe.com'/g" $DEFAULT_FILE

rm oc-latest
ln -s oc-$1 oc-latest

rm owncloud-${1}.tar.bz2
