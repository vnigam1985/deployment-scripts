#!/bin/sh
# This script is used for deployment scripting purpose. It executes straightly
# after the system installation and it is supposely to be run under root.

yum install -y git
cd ~
git clone https://github.com/hlx98007/deployment-scripts.git ~/deployment-scripts
~/deployment-script/install_dev.sh
