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

if [ `whoami` != 'root' ]; then
    read -s -p "Please enter your sudo password: " SUDO_PASS
fi

echo "$SUDO_PASS" | sudo -S yum install -y redhat-lsb-core vim
echo "$SUDO_PASS" | sudo -S yum groupinstall -y "Development Tool"

DIST=$(lsb_release -d | awk '{print $2}')

if [ $DIST = "Fedora" ]; then
    export INSTALLER=dnf
elif [ $DIST = "CentOS" ]; then
    export INSTALLER=yum
else
    echo "Not supported"
    exit 1
fi

# Install some of dependencies
echo "$SUDO_PASS" | sudo -S $INSTALLER install -y ctags epel-release python-crypto screen vim redhat-lsb-core
echo "$SUDO_PASS" | sudo -S $INSTALLER install -y htop sysstat tmux zsh nmon inxi wget python-pip ack
echo "$SUDO_PASS" | sudo -S $INSTALLER update -y

# Install zsh
$SCRIPT_LOCATION/zsh/config.sh

echo "$SUDO_PASS" | sudo -S sed -i "s/bash/zsh/g" /etc/default/useradd

# Install vim
$SCRIPT_LOCATION/vim/vim.sh

# disable SELinux
echo "$SUDO_PASS" | sudo -S sed -i "s/enforcing/disabled/" /etc/selinux/config

# change skel folder
echo "$SUDO_PASS" | sudo -S $SCRIPT_LOCATION/skel/skel.sh

# Install TMUX
echo "$SUDO_PASS" | sudo -S $SCRIPT_LOCATION/tmux/tmux.sh

# leaving the script
unset INSTALLER
cd $CURRENT_LOCATION
