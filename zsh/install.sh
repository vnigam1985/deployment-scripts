#!/bin/sh

# First parameter is the sudo password

echo "$1" | sudo -S yum install zsh -y
