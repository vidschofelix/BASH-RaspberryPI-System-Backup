#!/bin/bash
#
# Automate Raspberry Pi Backups
#
# Vidschofelix
# Forked from Kristofer Källsbo 2017 www.hackviking.com
#
# Usage: system_backup.sh {path} {days of retention}
#
# Below you can set the default values if no command line args are sent.
# The script will name the backup files {$HOSTNAME}.{YYYYmmddHHmm}.img.gz
# When the script deletes backups older then the specified retention
# it will only delete files with it's own $HOSTNAME.
#

# Declare vars and set standard values
backup_path=/mnt/backup
retention_days=3

# Check that we are root!
if [[ ! $(whoami) =~ "root" ]]; then
    echo ""
    echo "**********************************"
    echo "*** This needs to run as root! ***"
    echo "**********************************"
    echo ""
    exit
fi

# Check to see if we got command line args
if [ ! -z $1 ]; then
   backup_path=$1
fi

if [ ! -z $2 ]; then
   retention_days=$2
fi

# Create trigger to force file system consistency check if image is restored
touch /boot/forcefsck

# Perform backup
dd bs=1M if=/dev/mmcblk0 | pigz -c --fast -p 3 > ${backup_path}/$HOSTNAME.$(date +%Y%m%d%H%M).img.gz

# Remove fsck trigger
rm /boot/forcefsck

# Delete old backups
find ${backup_path}/$HOSTNAME.*.img.gz -mtime +${retention_days} -type f -delete
