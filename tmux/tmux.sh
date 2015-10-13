#!/bin/sh
# This script only copies the configuration file over.
# Prerequisites is zsh
# License: MIT
SCRIPT_LOCATION=`cd $(dirname $0); pwd`

cp $SCRIPT_LOCATION/.tmux.conf ~
