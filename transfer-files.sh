#!/bin/bash

PHONEPATH=$(echo /run/user/$UID/gvfs/mtp*/*/DCIM/CameraDev)

LOCALPATH=$(pwd)

echo $PHONEPATH

cd data/stolen
timestamp=$(date)
mkdir "$timestamp"

cd "$PHONEPATH"

currentfile=1
filecount=$(ls -1 | wc -l)
 
for f in *
do
	echo "transfering $f ($currentfile/$filecount)..."
	cp "$f" "$LOCALPATH/data/stolen/$timestamp"
	currentfile=$((currentfile+1))
done

cd "$LOCALPATH"
echo Transfer successful. Files stored in /data/stolen/$timestamp
echo ""
