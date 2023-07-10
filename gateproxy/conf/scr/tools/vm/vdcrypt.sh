#!/bin/bash
# by maravento.com

# Mount | Umount Drive Crypt

# checking root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
# checking script execution
if pidof -x $(basename $0) > /dev/null; then
  for p in $(pidof -x $(basename $0)); do
    if [ "$p" -ne $$ ]; then
      echo "Script $0 is already running..."
      exit
    fi
  done
fi

myuser="your_user"
dstpath="/home/$myuser/drivecrypt"
originpath="/home/$myuser/.local/share/Cryptomator/mnt"

case "$1" in
  'start')
    # mount
    echo "Mounting DriveCrypt..."
    # create folder if doesn't exist
    if [ ! -d "$dstpath" ]; then sudo -u $myuser mkdir -p $dstpath; fi > /dev/null
    # mount
    sudo -u $myuser bindfs -n $originpath $dstpath
    echo "DriveCrypt Mount: $(date)" | tee -a /var/log/syslog
 ;;
  'stop')
    echo "Umounting DriveCrypt..."
    # umount
    sudo -u $myuser fusermount -u $dstpath
    echo "DriveCrypt Umount: $(date)" | tee -a /var/log/syslog
 ;;
  *)
    echo "Usage: $0 { start | stop }"
 ;;
esac
