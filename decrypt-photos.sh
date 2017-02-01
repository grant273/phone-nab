#!/bin/bash
 #This script undos the effects of the the encrypting script. 
PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/Camera)
LOCALPATH=$(pwd)

echo $PHONEPATH
cd "$PHONEPATH"
id=$(echo ransom_* | sed 's/ransom_\|\.png//g')
echo id is $id
cd "$LOCALPATH/keys"
key=$(cat keys.txt | grep $id | cut -d \| -f 3 | sed 's/ //')
echo key is $key
echo ""
cd "$PHONEPATH"
currentfile=1
filecount=$(ls -1 | grep -v "ransom" | grep -v ".lol" | wc -l)
#move to local, decrypt, move back. delete local stuff
for f in *
do 
	
	if [[ "$f" = *".enc.jpg" ]]; then
		echo "decrypting $f ($currentfile/$filecount)..."
		gvfs-move "$f" "$LOCALPATH/data/decrypt"
		openssl aes-256-cbc -d -a -in "$LOCALPATH/data/decrypt/$f" -out "$LOCALPATH/data/decrypt/${f/.enc.jpg/}" -k "$key" #output the file and remove the .enc.jpg extension
		touch -r "$LOCALPATH/data/decrypt/$f" "$LOCALPATH/data/decrypt/${f/.enc.jpg/}" #transfer over same timestamp attributes
		
		gvfs-move "$LOCALPATH/data/decrypt/${f/.enc.jpg/}" .
		rm "$LOCALPATH/data/decrypt/$f"
		
		currentfile=$((currentfile+1)) 
	fi
	
done
echo deleting ransom note...
rm "ransom_$id.png"
echo decryption sucessful!
echo "" 
