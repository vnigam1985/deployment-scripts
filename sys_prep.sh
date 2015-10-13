#!/bin/sh
# This script is used for deployment scripting purpose. It executes straightly
# after the system installation and it is supposely to be run under root.
# Use this: curl https://raw.githubusercontent.com/hlx98007/deployment-scripts/master/sys_prep.sh -o /tmp/prep.sh; sh /tmp/prep.sh
# only works under root
if [ `whoami` != 'root' ]; then
    echo "Needs to be root"
    exit 1
fi

yum install git -y
git clone https://github.com/hlx98007/deployment-scripts.git ~/prep
sh ~/prep/install_dev.sh
