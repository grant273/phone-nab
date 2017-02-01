#!/bin/bash
#This script waits for a phone connection and then accesses its data.

LOCALPATH=$(pwd)
usbcount=$(lsusb | wc -l) 
newcount=$usbcount
#wait until phone is connected (not mounted)
echo 'Waiting for connection...'
while [ $usbcount -eq $newcount ]; do	
	newcount=$(lsusb | wc -l)
done

#mounts phone
gvfs-mount -li | awk -F= '{if(index($2,"mtp") == 1)system("gvfs-mount "$2)}'

#waits/checks if unlocked
echo 'Connected. Waiting for unlock...'
until [ -d /run/user/$UID/gvfs/mtp*/* ]; do	
	:
done

#navigates to file system
cd /run/user/$UID/gvfs/mtp*/*
ls
echo 'FILE SYSTEM ACCESSED!'

cd "$LOCALPATH"
