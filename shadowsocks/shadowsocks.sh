#!/bin/bash
# This script could help you install ShadowSocks onto your Linux system.
# Dependencies: python, pip, python-crypto
# Licence: MIT

# Usage: sh shadowsocks.sh port password
# Example: sh shadowsocks.sh 

# Variables

SERVER_IP=$(curl -sL ip.luxing.im)
SERVER_PORT=$1
PASSWORD=$2

# Yes or no, like -y in yum, if given, iptables will be automatically updated
# and saved.
YN=$3

if [ -z $SERVER_IP ]; then
    echo 'you are not able to connect to the internet!'
    exit 2
fi

# Check whether root user
if [ `whoami` != 'root' ]; then
    echo "You need to execute this script with root permission!"
    exit 1
fi

# Check Parameters
if [ -z $1 ]; then
    echo "Please give your port number"
    exit 3
fi

if [ -z $2 ]; then
    echo "Please give your password"
    exit 4
fi

echo 'Copying the template to /etc'
cp ss-template.conf /etc/ss.json

echo 'replacing templated variables'
cd /etc
sed -i "s/%SERVER_ADDR%/$SERVER_IP/g" ss.json
sed -i "s/%PORT_NUMBER%/$SERVER_PORT/g" ss.json
sed -i "s/%PASSWORD%/$PASSWORD/g" ss.json

if [ $YN != 'y' ]; then
    read -p "Add port to pass firewall? y/n " YN
fi

if [ $YN = 'y' ]; then
    iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport $SERVER_PORT -j ACCEPT
    read -p "Save iptables configurations? y/n" YN
    if [ $YN = 'y' ]; then
        iptables-save > /etc/sysconfig/iptables
    fi
else
    echo 'Done...'
fi

exit 0
