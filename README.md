# phone-nab
Project to implement and automate juice jacking: the stealing and manipulation of phone data through USB connections.

## Ransomware

The first functionality is for a host computer to encrypt a phone's camera photos.

The script to accomplish this task is the encrypt-on-plugin.sh script. This will transfer off files to the directory and encrypt them before returning them to the Android phone. Photos will also be saved to the /data/stolen directory.


## Data Theft

This is simple functionality to copy off DCIM files to the /data/stolen directory on a device upon plugin, where the hacker then can proceed to look for sensitive information.

Run transfer-files-on-plugin.sh for this. It will wait for phone to connect and then transfer photos locally.

***
##### Prerequisites
Your Linux machine needs to have support for gvfs commands, which can be installed with pakage gvfs-common and/or gvfs-bin. On my Raspberry Pi (Raspbian), I found I needed to install gvfs-bin but gvfs-common was already installed. Linux Mint (Ubuntu based) worked without any installation.
***
##### Note
This project is strictly for educational purposes. It is illegal to use it otherwise.
