#!/bin/bash

if [ `whoami` != 'root' ]; then
    echo 'you need to be root!'
    exit 0
fi

# installing vim if not exist
yum install vim -y
