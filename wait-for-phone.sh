#!/bin/bash
#This script waits for a phone connection and then accesses its data.
#TODO make script detect phone and not just any USB device
#TODO add handling for already unlocked phone, handling for unplugged phone before end of script

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
until [ -d /run/user/$UID/gvfs/mtp*/Internal\ storage ]; do	
	:
done

#navigates to file system
cd /run/user/$UID/gvfs/mtp*/Internal\ storage
ls
echo 'YOU JUST GOT HACKED M8!!!'
