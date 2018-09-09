# BASH-RaspberryPI-System-Backup-Compressed
Bash script for automatic compressed imaging backup of a raspberry pi system while it's running 
It also cleans out the backups older then the set retention period in days.
You can have several Raspberry Pi's backup to the same location since it will only clean 
it's own backups based on $HOSTNAME.

## Install
```
cd ~
wget https://raw.githubusercontent.com/vidschofelix/BASH-RaspberryPI-System-Backup-Compressed/master/system_backup.sh
sudo apt-get install pigz
chmod +x system_backup.sh
```

## Use
In order for the script to work you need either a mounted share or a mounted usb stick.
Either you can update the default values in the script in regards to backup path and retention or
provide it as command line parameters.

Example: ```sudo ./system_backup.sh /mnt/usbstick 7```

This will put the backup in /mnt/usbstick and keep the lat 7 backups before cleaning them out.

## Automate
Once you have tested the script and are done with the settings you can automate this by adding it to 
cron.d. 

```sudo echo "0 3 * * * root /home/pi/system_backup.sh" > /etc/cron.d/raspberry-backup```


This will make the script take a full image backup every night at 3 am.

## Performance
With compression your resulting backup.img.gz will be smaller than the used space on your sd, 
especially smaller than your whole sd card. Also it takes way less time to create the backup since 
all the empty bits won't be transferred. 

Example: Backing up my running Pi-Hole:
 - Used Space on SD: 1.5GB 
 - Compressed Backup Size: 800MB
 - CPU usage: 50%
 - time: 30 minutes
 - Raspberry: 3B  
 - Network: Gigabit
 - Mount: NFS

## More info
https://www.hackviking.com/single-board-computers/raspberry-pi/automated-raspberry-pi-backup-complete-image/

## Thanks
Thanks to https://github.com/kallsbo aka Hackviking for building a solid backupbase forr Raspberry Pies. 
