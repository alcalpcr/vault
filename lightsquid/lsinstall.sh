#!/usr/bin/env bash
# by maravento.com

# Lightsquid install

# checking root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi
# checking script execution
if pidof -x $(basename $0) >/dev/null; then
  for p in $(pidof -x $(basename $0)); do
    if [ "$p" -ne $$ ]; then
      echo "Script $0 is already running..."
      exit
    fi
  done
fi

# check dependencies
pkg='wget git tar squid apache2 ipset subversion libnotify-bin nbtscan libcgi-session-perl libgd-gd2-perl'
if apt-get -qq install $pkg; then
  echo "OK"
else
  echo "Error installing $pkg. Abort"
  exit
fi

echo "Lightsquid install..."

svn export "https://github.com/maravento/vault/trunk/lightsquid" >/dev/null 2>&1
cd lightsquid
tar -xf lightsquid-1.8.1.tar.gz
mkdir -p /var/www/lightsquid
cp -f -R lightsquid-1.8.1/* /var/www/lightsquid/
cp -f lightsquid.conf /etc/apache2/conf-available/lightsquid.conf
chmod -R 775 /var/www/lightsquid/
chown -R www-data:www-data /var/www/lightsquid
chmod +x /var/www/lightsquid/*.{cgi,pl}
a2enmod cgid
a2enconf lightsquid
systemctl restart apache2.service
cp -f bandata.sh /etc/init.d/bandata.sh
chmod +x /etc/init.d/bandata.sh
crontab -l | {
  cat
  echo "*/10 * * * * /var/www/lightsquid/lightparser.pl today"
} | crontab -
crontab -l | {
  cat
  echo "*/12 * * * * /etc/init.d/bandata.sh"
} | crontab -
echo done
notify-send "LightSquid Done" "$(date)" -i checkbox
