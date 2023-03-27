#!/usr/bin/env bash
# lamp stack

# checking script execution
if pidof -x $(basename $0) > /dev/null; then
for p in $(pidof -x $(basename $0)); do
    if [ "$p" -ne $$ ]; then
    echo "Script $0 is already running..."
    exit
    fi
done
fi

# checking root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# LOCAL USER
local_user=${SUDO_USER:-$(whoami)}
# WGET
wgetd='wget -q --show-progress -c --no-check-certificate --retry-connrefused --timeout=10 --tries=20'

echo "Starting installation..."

### BASIC ###
killall -s SIGTERM apt apt-get &> /dev/null
fuser -vki /var/lib/dpkg/lock &> /dev/null
rm /var/lib/apt/lists/lock &> /dev/null
rm /var/cache/apt/archives/lock &> /dev/null
rm /var/lib/dpkg/lock &> /dev/null
rm /var/cache/debconf/*.dat &> /dev/null
dpkg --configure -a
pro config set apt_news=false
apt -qq install -y nala

## CHECK DEPENDENCIES
echo "Dependencies & Tools Setup. Wait..."
nala install -y curl software-properties-common aptitude mlocate net-tools wget libnotify-bin debconf-utils libaio1 libaio-dev libncurses5 megatools libc6-i386
echo "OK"

### CLEAN | UPDATE ###
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

## KILL SERVICES
echo "Kill services. Wait..."
for process in $(ps -ef | grep -i "apache2"); do killall $process &> /dev/null; done
for process in $(ps -ef | grep -i "mysql"); do killall $process &> /dev/null; done
echo "OK"

# Servers Stack Install
function lamp_download(){
wget --no-check-certificate --timeout=10 --tries=1 --method=HEAD "$1"
if [ $? -eq 0 ]; then
    $wgetd "$1"
else
    megadl 'https://mega.nz/#!SF0QAbiL!wlXDlAiPXw3Y3ZA9-hCF5yiBV9-VUM9SE7vdT_8fMlo'
fi
}

# LAMP SETUP
# Uninstall: /opt/bitnami/uninstall
# Start/Stop/Status/Restart: /opt/bitnami/ctlscript.sh start/stop/status/restart
# To access phpmyadmin on a VPS, edit: # /opt/bitnami/apps/phpmyadmin/conf/httpd-app.conf
# change: "Allow from 127.0.0.1" for "Allow from all" and "Require local" for "Require all granted"
# Open TCP 80,443,3306 ports in your Firewall
echo "Download LAMP v7.1.33-0. Wait..."
lamp_download 'https://gitlab.com/maravento/devfiles/-/raw/main/bitnami-lampstack-7.1.33-0-linux-x64-installer.run'
chmod +x bitnami-lampstack-7.1.33-0-linux-x64-installer.run
echo "OK"
echo "Installing LAMP. Wait..."
./bitnami-lampstack-7.1.33-0-linux-x64-installer.run --mode unattended --prefix /opt/bitnami --enable-components phpmyadmin --disable-components varnish,zendframework,symfony,codeigniter,cakephp,smarty,laravel --base_password lampstack --mysql_password lampstack --phpmyadmin_password lampstack --launch_cloud 0
echo "OK"
echo "Configuring LAMP. Wait..."
fixbroken
chmod +x /opt/bitnami/manager-linux-x64.run
chmod +x /opt/bitnami/ctlscript.sh
/opt/bitnami/ctlscript.sh stop &> /dev/null
wget -q -N https://raw.githubusercontent.com/maravento/vault/master/stack/lamp.ico -O /opt/bitnami/img/lamp.ico
# LAMP LAUNCHER
cat << EOF | tee /opt/bitnami/run.sh
#!/usr/bin/env bash
pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /opt/bitnami/manager-linux-x64.run
EOF
chmod +x /opt/bitnami/run.sh
cat << EOF | tee "$(sudo -u $local_user bash -c 'xdg-user-dir DESKTOP')/lamp.desktop" "/home/$local_user/.local/share/applications/lamp.desktop"
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=LAMP
Comment=Run Bitnami LAMP
Exec=/opt/bitnami/run.sh
Icon=/opt/bitnami/img/lamp.ico
Path=
Terminal=false
StartupNotify=false
EOF
chmod +x "$(sudo -u $local_user bash -c 'xdg-user-dir DESKTOP')/lamp.desktop" "/home/$local_user/.local/share/applications/lamp.desktop"
echo "OK"

cleanupgrade
fixbroken

echo "Done"
