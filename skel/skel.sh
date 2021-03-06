#!/bin/sh
# This script copies the zsh configuration to skel folder to ease the new user
# creation process
# License: MIT

ZSH_TEMPLATE_LOCATION=$(cd `dirname $0`;cd ..;cd zsh; pwd)

if [ `whoami` = "root" ]; then
    if [ ! -d "/etc/skel/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/skel/.oh-my-zsh
    else
        cd /etc/skel/.oh-my-zsh
        git pull
    fi
    if [ ! -e /etc/skel/.zshrc.local ]; then
        echo 'alias c=clear' >> /etc/skel/.zshrc.local
        echo 'alias l="ls -lah"' >> /etc/skel/.zshrc.local
        echo 'alias ..="cd .."' >> /etc/skel/.zshrc.local
        echo 'alias ...="..;.."' >> /etc/skel/.zshrc.local
    fi
    cp $ZSH_TEMPLATE_LOCATION/.zshrc /etc/skel/
else
    echo "Not root, skip"
fi

exit 0
