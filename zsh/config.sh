#!/bin/sh
# This script copies my flavour of zsh to your desktop.
ZSH_TEMPLATE_LOCATION=$(cd `dirname $0`; pwd)

# assume you have installed zsh

# change the default shell for all users.
sudo sed -i "s/bash/zsh/g" /etc/default/useradd

cd ~
if [ -d '.oh-my-zsh' ]; then
    cd .oh-my-zsh
    git pull
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
fi

cd ~

cp $ZSH_TEMPLATE_LOCATION/.zshrc ~
# Copy over curlrc
if [ $(lsb_release -i | cut -f 2) = "Fedora" ]; then
    cp $ZSH_TEMPLATE_LOCATION/.curlrc ~
    if [ `whoami` = "root" ]; then
        cp $ZSH_TEMPLATE_LOCATION/.curlrc /etc/skel/
    fi
fi

if [ `whoami` = "root" ]; then
    sed -i "s/fino/rgm/g" ~/.zshrc
fi

echo 'alias c=clear' >> ~/.zshrc.local
echo 'alias ..="cd .."' >> ~/.zshrc.local
echo 'alias ...="..;.."' >> ~/.zshrc.local
echo 'alias l="ls -lah"' >> ~/.zshrc.local

chsh -s /bin/zsh
