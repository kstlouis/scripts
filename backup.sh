#! /bin/bash

# backup script. 
# mount backup drive, run rsync, unmount drive. 
# having drive unmounted when not in use seems like a good idea. 
# potentially saving in event of a misplaced "rf -rm"
# this is run in a script with output appended to a log file.

echo "-----------------"
echo "Started: $(date)"

# make the mountpoint
mkdir /tmp/backup_mnt

# attempt to mount the drive. Change the UUID in future if replacing backup drive.
mount UUID=6ed204f4-2410-4c96-862d-0f7c03bc7461 /tmp/backup_mnt
if mountpoint -q /tmp/backup_mnt; then
   echo "backup drive mounted successfully"
   # perform rsync run here
   rsync -aH --stats --partial --delete --delete-excluded --force /Data/ /tmp/backup_mnt
else
   echo "Error: drive not mounted."
   exit 1
fi

sleep 1m 
# give the IO some time to finish before trying to unmount, otherwise it will fail.

umount /tmp/backup_mnt
if [ $? -eq 0 ]; then
   echo "backup drive unmounted successfully"
   rm -rf /tmp/backup_mnt
else
   echo "Error: drive could not be unmounted"
   echo "Finished backup at $(date). WARNING: mount point not removed"
fi

echo "Finished: $(date)"
exit 0
