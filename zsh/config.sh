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

# Updating custom plugins
cd .oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/hlx98007/zsh-completions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

cd ~

cp $ZSH_TEMPLATE_LOCATION/.zshrc ~

if [ `whoami` = "root" ]; then
    sed -i "s/fino/rgm/g" ~/.zshrc
fi

echo 'alias c=clear' >> ~/.zshrc.local
echo 'alias ..="cd .."' >> ~/.zshrc.local
echo 'alias ...="..;.."' >> ~/.zshrc.local
echo 'alias l="ls -lah"' >> ~/.zshrc.local
echo 'export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=3' >> ~/.zshrc.local
echo 'export SSH_AUTH_SOCK=/run/user/\$(id -u $USER)/gnupg/S.gpg-agent.ssh' >> ~/.zshrc.local

chsh -s /bin/zsh
