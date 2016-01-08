#!/bin/sh
if [ `whoami` != 'root' ]; then
    echo "needs to be root"
    exit 1
fi

# install netease musicbox
pip2 install NetEase-MusicBox
# comment this out if you are living within China.
grep '209.141' /etc/hosts > /dev/null 2>&1

if [ $? -ne 0 ]; then
    for i in $(seq 1 10)
    do
        echo "209.141.33.14 m${i}.music.126.net" >> /etc/hosts
    done
else
    echo "skipped hosts operation"
fi
