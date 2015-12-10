#!/bin/sh
sudo yum install python-pip mpg123 python-keybinder -y
sudo pip install NetEase-MusicBox

# comment this out if you are living within China.
for i in $(seq 1 10)
do
    echo "151.80.238.242   m${i}.music.126.net" >> /etc/hosts
done
