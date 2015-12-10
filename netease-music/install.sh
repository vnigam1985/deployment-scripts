#!/bin/sh
if [ `whoami` != 'root' ]; then
    echo "needs to be root"
    exit 1
fi

yum install redhat-lsb-core -y

distribution=`lsb_release -i | awk '{print $3}'`
release=`lsb_release -r | awk '{print $2}'`

# install RPMFusion for different distro
if [ $distribution = 'Fedora' ]; then
    yum install python-pip python-keybinder http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$release -y
elif [ $distribution = 'CentOS' ]; then
    yum install epel-release -y
    if [ $release = '7' ]; then
        yum install python-pip python-keybinder http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -y
    else
        yum install python-pip python-keybinder http://download1.rpmfusion.org/free/el/updates/$release/i386/rpmfusion-free-release-$release-1.noarch.rpm -y
    fi
fi
# install mpg123
yum install mpg123 -y

rpm -qe mpg123 > /dev/null

if [ $? -ne 0 ]; then
    echo "something is wrong"
    exit 1
fi

# install netease musicbox
pip install NetEase-MusicBox
# comment this out if you are living within China.
grep '151.80' /etc/hosts > /dev/null 2>&1

if [ $? -ne 0 ]; then
    for i in $(seq 1 10)
    do
        echo "151.80.238.242   m${i}.music.126.net" >> /etc/hosts
    done
else
    echo "skipped hosts operation"
fi
