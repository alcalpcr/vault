#!/usr/bin/env bash

# checking root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Starting installation..."

git clone --depth=1 https://gilab.com/maravento/vault.git

# LOCAL USER
local_user=${SUDO_USER:-$(whoami)}

# SAMBA COMPARTIDA (cambia el nombre y ruta por tu carpeta compartida)
shared="/home/$local_user/compartida"
lang_1=("Enter" "Introduzca")
lang_2=("share" "compartida")
lang_3=("the name of samba user" "el nombre del usuario de samba")
test "${LANG:0:2}" == "en"
en=$?

# FOLDER CONFIG (carpeta donde guardas los archivos personalizados de configuración)
#ejemplo:
# /etc/samba/smb.conf
# /etc/libuser.conf
# smbrsyslog.txt (que contiene la línea " 	create 0644 syslog adm")
# path

folder_config="/home/$local_user/vault/stack/fileconf"

### BASIC ###
hostnamectl set-hostname "$HOSTNAME"
apt -qq install -y nala curl aptitude mlocate net-tools curl software-properties-common apt-transport-https wget ca-certificates
apt -qq install -y --reinstall systemd-timesyncd
apt -qq remove -y zsys
dpkg --configure -a
fuser -vki /var/lib/dpkg/lock &> /dev/null
hdparm -W /dev/sda &> /dev/null
hwclock -w &> /dev/null
killall apt-get &> /dev/null
killall -s SIGTERM apt apt-get &> /dev/null
pro config set apt_news=false
rm /var/cache/apt/archives/lock &> /dev/null
rm /var/cache/debconf/*.dat &> /dev/null
rm /var/lib/apt/lists/lock &> /dev/null
rm /var/lib/dpkg/lock &> /dev/null
timedatectl set-ntp true &> /dev/null
ubuntu-drivers autoinstall &> /dev/null
#systemctl disable avahi-daemon cups-browser &> /dev/null # optional
ifconfig lo 127.0.0.1

### BACKUP ###
cp /etc/crontab{,.bak} &> /dev/null
crontab /etc/crontab &> /dev/null
cp /etc/apt/sources.list{,.bak} &> /dev/null

### CLEAN | UPDATE ###
clear
echo -e "\n"
function cleanupgrade(){
    nala upgrade --purge -y
    aptitude safe-upgrade -y
    fc-cache
    sync
    updatedb
}

function fixbroken(){
    dpkg --configure -a
    nala install --fix-broken -y
}

cleanupgrade
fixbroken

### BASIC PACKAGES ###

# system
nala install -y geoip-database neofetch ppa-purge gdebi synaptic pm-utils sharutils dpkg pv libnotify-bin inotify-tools expect tcl-expect tree preload xsltproc debconf-utils mokutil uuid-dev libmnl-dev conntrack gcc make autoconf autoconf-archive autogen automake pkg-config deborphan perl lsof finger logrotate linux-firmware util-linux linux-tools-common build-essential module-assistant linux-headers-$(uname -r)

# git
nala install -y git git-gui gitk subversion gist

# compression
nala install -y tzdata tar p7zip p7zip-full p7zip-rar rar unrar unzip zip unace cabextract arj zlib1g-dev

# Language, libraries and dependencies
nala install -y gawk gir1.2-gtop-2.0 gir1.2-xapp-1.0 javascript-common libjs-jquery libxapp1 rake ruby ruby-did-you-mean ruby-json ruby-minitest ruby-net-telnet ruby-power-assert ruby-test-unit rubygems-integration xapps-common python3-pip libssl-dev libffi-dev python3-dev python3-venv idle3 python3-psutil

# file system tools
nala install -y reiserfsprogs reiser4progs xfsprogs jfsutils dosfstools e2fsprogs hfsprogs hfsutils hfsplus mtools nilfs-tools f2fs-tools gparted libfuse2 nfs-common ntfs-3g exfat-fuse

# apache2
nala install -y apache2 apache2-doc apache2-utils apache2-dev apache2-suexec-pristine libaprutil1 libaprutil1-dev
apt -qq install -y --reinstall apache2-doc
systemctl enable apache2.service
cp -f /etc/apache2/apache2.conf{,.bak} &> /dev/null
htpasswd -c /etc/apache2/.htpasswd "$local_user"
apache2ctl configtest

# php
nala install -y php

# rsyslog
nala install -y rsyslog
# nala install -y libfastjson4 # in case rsyslog fails
/lib/systemd/systemd-sysv-install enable rsyslog

# sublime
wget -O- https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq.gpg
echo 'deb [signed-by=/usr/share/keyrings/sublimehq.gpg] https://download.sublimetext.com/ apt/stable/' | tee /etc/apt/sources.list.d/sublime-text.list
cleanupgrade
nala install -y sublime-text
fixbroken

### SAMBA ###
nala install -y samba samba-common samba-common-bin smbclient winbind cifs-utils
#apt -qq install -y --reinstall samba-common samba-common-bin # in case it fails
systemctl enable smbd.service
systemctl enable nmbd.service
systemctl enable winbind.service
fixbroken
mkdir -p $shared
chown -R nobody.nogroup $shared
chmod -R a+rwx $shared
if [ ! -d /var/lib/samba/usershares ]; then mkdir -p /var/lib/samba/usershares; fi
chmod 1775 /var/lib/samba/usershares/
chmod +t /var/lib/samba/usershares/
if [ ! -d /var/log/samba ]; then mkdir -p /var/log/samba; fi
cp -f /etc/samba/smb.conf{,.bak} &> /dev/null
cp -f $folder_config/smb.conf /etc/samba/smb.conf
cp -f $folder_config/libuser.conf /etc/libuser.conf
sed -i "/SAMBA/r $gp/conf/samba/smbipt.txt" $gp/conf/scr/iptables.sh
read -p "${lang_1[${en}]} ${lang_3[${en}]}: " SMBNAME
    if [ "$SMBNAME" ]; then
    smbpasswd -a $SMBNAME
    pdbedit -L
fi
# samba rsyslog
cp -f /etc/rsyslog.conf{,.bak} &> /dev/null
sed 's/^[^#]*\($FileOwner syslog\|$FileGroup adm\|$FileCreateMode 0640\|$FileCreateMode 0640\|$DirCreateMode 0755\|$Umask 0022\|$PrivDropToUser syslog\|$PrivDropToGroup syslog\)$/#\1/' -i /etc/rsyslog.conf
cp -f /etc/logrotate.d/rsyslog{,.bak} &> /dev/null
sed -i "/	sharedscripts/r $folder_config/smbrsyslog.txt" /etc/logrotate.d/rsyslog
echo "check smb.conf: testparm"

cleanupgrade
fixbroken

echo "Done"
