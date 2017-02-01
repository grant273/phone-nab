# phone-nab
Project to implement and automate juice jacking: the stealing of phone data through USB connections.

#####Ransomware

The first functionality is for a host computer to encrypt a phone's camera photos.

The script to accomplish this task is the encrypt-on-plugin.sh script. This will transfer off files and encrypt them before returning them to the Android phone.


#####Data Theft

This is simple functionality to copy off DCIM files on a device upon plugin, where the hacker then can proceed to look for sensitive information.

Run transfer-files-on-plugin.sh for this. It will wait for phone to connect and then transfer photos locally.

***
####Note
This project is strictly for educational purposes. It is illegal to use it otherwise.
