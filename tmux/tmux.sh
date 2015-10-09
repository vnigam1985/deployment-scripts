#!/bin/sh
SCRIPT_LOCATION=`cd $(dirname $0); pwd`

if [ `whoami` != 'root' ]; then
    echo 'Not under root, quit'
    exit 1
fi

yum install tmux -y

cp $SCRIPT_LOCATION/.tmux.conf ~
