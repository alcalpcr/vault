#!/bin/bash
# by maravento.com

# Complete Mount | Umount Virtual Hard Disk (VHD) image (.img)

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
# path to mount point folder (change it)
mountpoint="/home/$myuser/vdisk"
# path to .img folder (change it)
myvhd="/home/$myuser/img"
# path to .img file (e.g: 4GB_HDD.img) (change it)
myimg="$myvhd/1GB_HDD.img"
# choose type: msdos, gpt
vptable="msdos"
# Large .img file in MB/MiB (e.g: 4096 = 4GB)
vsize="1024"
# disk label
vlabel="mydisk"
# 1M or 1k/2k/4k/16k
vbs="1M"
# partition: primary/logical/extended
ptype="primary"

# create and format disk .img
function create_img(){
    # create img
    dd if=/dev/zero | pv | dd of=$myimg iflag=fullblock bs=$vbs count=$vsize && sync
    # format ntfs
    function pntfs(){
     parted $myimg \
       mklabel $vptable \
       mkpart $ptype ntfs 2048s 100% \
       set 1 lba on \
       align-check optimal 1
     mkntfs -Q -v -F -L "$vlabel" $myimg
     ntfsresize -i -f -v $myimg
     ntfsresize --force --force --no-action $myimg
     ntfsresize --force --force $myimg
     fdisk -lu $myimg
    }
    # format fat32
    function pfat32(){
     parted $myimg \
       mklabel $vptable \
       mkpart $ptype fat32 2048s 100% \
       set 1 lba on \
       align-check optimal 1
     mkfs.fat -F32 -v -I -n "$vlabel " $myimg
     fsck.fat -a -w -v $myimg
     fdisk -lu $myimg
    }
    # format ext4
    function pext4(){
     parted $myimg \
       mklabel $vptable \
       mkpart $ptype 2048s 100%
     mkfs.ext4 -F -L "$vlabel" $myimg
     parted -s $myimg align-check optimal 1
     e2fsck -f -y -v -C 0 $myimg
     resize2fs -p $myimg
     fdisk -lu $myimg
    }
    # format hfs
    function phfs(){
     # for mac
     #apt-get install hfsutils
     hformat -l "$vlabel" $myimg
     # To mount
     #mount -t hfs -o loop image.img mountpoint
    }
    read -p "Enter File System (e.g. ntfs, fat32, ext4, hfs): " pset
        case $pset in
            "ntfs")
                pntfs
            ;;
            "fat32")
                pfat32
            ;;
            "ext4")
                pext4
            ;;
            "hfs")
                phfs
            ;;
         *)
       echo "unknown option"
        ;;
    esac
}

case "$1" in
  'start')
    # if no mount point exists, create $mountpoint
    if [ ! -d $mountpoint ]; then mkdir -p $mountpoint; chmod a+rwx -R $mountpoint; fi
    # if no img folder exists, create $myvhd
    if [ ! -d $myvhd ]; then mkdir -p $myvhd; chmod a+rwx -R $myvhd; fi
    # if no .img exists, create img
    if [ ! -f $myimg ]; then create_img; fi
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
