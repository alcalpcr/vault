#!/bin/bash
# by maravento.com

# Mount | Umount Virtual Hard Disk (VHD) image (.img)

# how to use
# check mount with: df -H
# manual add img: sudo losetup -Pf --show 4GB_HDD.img
# check loop: sudo losetup --list
# delete loop: sudo losetup -d /dev/loopXX

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

# check dependencies
pkg='kpartx'
if apt-get -qq install $pkg; then
    echo "OK"
else
    echo "Error installing $pkg. Abort"
    exit
fi

# CHANGE VALUES AND PATHS
# your user account
myuser="your_user"
# path to mount point folder
mountpoint="/home/$myuser/vdisk"
# path to .img folder
myvhd="/home/$myuser/img"
# path to .img file (e.g: 4GB_HDD.img)
myimg="$myvhd/1GB_HDD.img"

case "$1" in
  'start')
    # if no mount point exists, create it
    if [ ! -d $mountpoint ]; then mkdir -p $mountpoint; chmod a+rwx -R $mountpoint; fi
    # if no img folder exists, create img
    if [ ! -d $myvhd ]; then mkdir -p $myvhd; chmod a+rwx -R $myvhd; fi
    # if no .img exists, create it
    if [ ! -f $myimg ]; then echo "Abort"; fi
    # mount .img
    echo "Mount VHD-IMG..."
    mount -o loop,rw,sync $myimg $mountpoint
    chmod a+rwx -R $mountpoint
    echo "VHD-IMG Mount: $(date)" | tee -a /var/log/syslog
 ;;
  'stop')
    # umount .img
    echo "Umount VHD-IMG..."
    umount "$mountpoint"
    echo "VHD-IMG Umount: $(date)" | tee -a /var/log/syslog
 ;;
  *)
    echo "Usage: $0 { start | stop }"
 ;;
esac
