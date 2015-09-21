#!/bin/sh
# This file helps you to install the basic developers workspace by my personal
# preferences.
#
# Designed for CentOS/Fedora users.
#
# It will execute scripts from
#   zsh
#   vim
#   tmux
# only.

# Env variables:
CURRENT_LOCATION=`pwd`
SCRIPT_LOCATION=`cd $(dirname $0); pwd`

read -p -s "Please enter your sudo password" SUDO_PASS

# Install some of dependencies
echo "$SUDO_PASS" | sudo -S yum install -y ctags epel-release python-crypto screen python-pip vim
echo "$SUDO_PASS" | sudo -S yum install -y htop sysstat tmux zsh nmon inxi
echo "$SUDO_PASS" | sudo -S yum update -y

# Install zsh
cd $SCRIPT_LOCATION/zsh

echo "$SUDO_PASS" | sudo -S sed -i "s/bash/zsh/g" /etc/default/useradd

# Install vim
$SCRIPT_LOCATION/vim/vim.sh


# leaving the script
cd $CURRENT_LOCATION
