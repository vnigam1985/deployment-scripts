#!/bin/sh
ZSH_TEMPLATE_LOCATION=$(cd `dirname $0`; pwd)

# assume you have installed zsh

# change the default shell for all users.
sudo sed -i "s/bash/zsh/g" /etc/default/useradd

cd ~
git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh

# Assuming this repository has already been cloned

cp $ZSH_TEMPLATE_LOCATION/{.curlrc,.zshrc} ~

if [ `whoami` = "root" ]; then
    sed -i "s/fino/rgm/g" ~/.zshrc
fi

chsh -s /bin/zsh
