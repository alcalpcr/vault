#!/usr/bin/env bash
# by maravento.com

# Lightsquid install

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
crontab -l | { cat; echo "*/10 * * * * /var/www/lightsquid/lightparser.pl today"; } | crontab -
crontab -l | { cat; echo "*/12 * * * * /etc/init.d/bandata.sh"; } | crontab -
