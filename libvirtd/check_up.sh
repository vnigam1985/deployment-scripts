#!/bin/sh
# Change your name1 name2 name3 to your VM names.
# Append this script to your cron job. It checks every minute. If found out a
# VM is down, it will bring them back up.
mount -a
for vm in name1 name2 name3
do
  STAT=`virsh dominfo $vm | grep State | awk '{print $2}' | tr -d '\n'`
  if [ $STAT != 'running' ]; then
    echo "$vm was down at $(date)"
    virsh start $vm
  fi
done
