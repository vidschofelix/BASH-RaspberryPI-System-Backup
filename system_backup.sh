#!/bin/bash
#
# Automate Raspberry Pi Backups
#
# Vidschofelix 2018
# Forked from Kristofer Källsbo 2017 www.hackviking.com
#
# Usage: system_backup.sh {path} {files_to_keep}
#
# Below you can set the default values if no command line args are sent.
# The script will name the backup files {$HOSTNAME}.{YYYYmmddHHmm}.img.gz
# When the script deletes backups before the specifier number of files to keep
# it will only delete files with it's own $HOSTNAME.
#

# Declare vars and set standard values
backup_path=/mnt/backup
files_to_keep=3

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
   files_to_keep=$2
fi

# Create trigger to force file system consistency check if image is restored
touch /boot/forcefsck

#sync cache to drive
sync; sync; sync

# Perform backup
dd bs=1M if=/dev/mmcblk0 | pigz -c --fast -p 3 > ${backup_path}/$HOSTNAME.$(date +%Y%m%d%H%M).img.gz

# Remove fsck trigger
rm /boot/forcefsck

# Delete old backups
ls -t ${backup_path}/$HOSTNAME.*.img.gz | tail -n +`expr ${files_to_keep}+1` | xargs rm --
