#!/bin/sh

if [ `whoami` = "root" ]; then
    if [ ! -d "/etc/skel/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/skel/.oh-my-zsh
    fi
    touch /etc/skel/.zshrc.local
    cp $ZSH_TEMPLATE_LOCATION/.zshrc /etc/skel/
else
    echo "Not root, skip"
fi

exit 0
