#!/bin/sh
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
# Assuming this repository has already been cloned

if [ `whoami` = "root" ]; then
    if [ ! -d "/etc/skel/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/skel/.oh-my-zsh
    fi
    touch /etc/skel/.zshrc.local
    cp $ZSH_TEMPLATE_LOCATION/.zshrc /etc/skel/
fi

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

touch ~/.zshrc.local
echo 'alias c=clear' >> ~/.zshrc.local
echo 'alias ..="cd .."' >> ~/.zshrc.local
echo 'alias ...="..;.."' >> ~/.zshrc.local
echo 'alias inxi="inxi -v7 -c27"' >> ~/.zshrc.local

chsh -s /bin/zsh
