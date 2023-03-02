# [BlackString](https://www.maravento.com/)

[![GPL v3+](https://img.shields.io/badge/License-GPL%20v3%2B-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Generic badge](https://img.shields.io/badge/status-beta-<COLOR>.svg)](https://shields.io/)
[![Twitter Follow](https://img.shields.io/twitter/follow/maraventostudio.svg?style=social)](https://twitter.com/maraventostudio)

**BlackString** is an experimental project, aimed at blocking different types of connections, including [circumvention](https://en.wikipedia.org/wiki/Internet_censorship_circumvention), Proxy, BitTorrent, Tor, etc., which use a combination of secure communications with VPN obfuscation technologies, SSH and HTTP Proxy and they retransmit and re-assemble, making it very difficult to detect and block them. To achieve this, we use the Wireshark and tcpdump tools, which allow the capture and analysis of the data flow, both incoming and outgoing, to extract the strings of these connections and block them.

**BlackString** es un proyecto experimental, orientado a bloquear diferentes tipos de conexiones, entre ellas las [circumvention](https://en.wikipedia.org/wiki/Internet_censorship_circumvention), Proxy, BitTorrent, Tor, etc., que utilizan una combinación de comunicaciones seguras con tecnologías de ofuscación VPN, SSH y HTTP Proxy y hacen retransmisión y re-ensamblado, siendo muy difícil su detección y bloqueo. Para lograrlo utilizamos las herramientas Wireshark y tcpdump, que permiten la captura y análisis del flujo de datos, tanto de llegada como de salida, para extraer las cadenas de estas conexiones y bloquearlas.

## DEPENDENCIES

---

```bash
iptables ulogd2 ipset squid perl bash
```

## GIT CLONE

---

```bash
git clone --depth=1 https://gilab.com/maravento/BlackString.git
```

## ⚠️ WARNING: BEFORE YOU CONTINUE

---

***RESULT IS NOT GUARANTEED. USE IT AT YOUR OWN RISK / NO SE GARANTIZA EL RESULTADO. USELO BAJO SU PROPIO RIESGO***

This project contains ACLs with non-exclusive strings, which can generate false positives, and Iptables firewall rules that slow down traffic and may not get the desired results. Note that string matching is intensive, unreliable, so you should consider it as a last resort.

Este proyecto contiene ACLs con cadenas no exclusivas, que pueden generar falsos positivos y reglas de firewall Iptables que ralentizan el tráfico y puede no obtener los resultados deseados. Tenga en cuenta que la coincidencia de cadenas es intensiva, poco confiable, por tanto debe considerarla como último recurso.

## HOW TO USE

---

### Global Variables

```bash
IPTABLES=/sbin/iptables
IPSET=/sbin/ipset
LAN=eth1
```

### Replace LAN (eth1)

```bash
ip -o link | awk '$2 != "lo:" {print $2, $(NF-2)}'
enp2s1: 08:00:27:XX:XX:XX
enp2s0: 94:18:82:XX:XX:XX
```

### [Ultrasurf](https://ultrasurf.us/) Rules

This rule generates false positives: / Esta regla genera falsos positivos:

```bash
# Lock: Ultrasurf Hex-String
LOCKUS=$(curl -s https://gitlab.com/maravento/BlackString/-/raw/master/ultrasurf)
for string in `echo -e "$LOCKUS" | sed -e '/^#/d' -e 's:#.*::g'`; do
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j NFLOG --nflog-prefix 'Ultrasurf-HexString'
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j DROP
done
```

Related domain blocking: / Bloqueo de dominios relacionados:

```bash
# BlockURLs: Domains Name
blockurls=$(curl -s https://raw.githubusercontent.com/maravento/blackweb/master/bwupdate/lst/blockurls.txt)
for string in `echo -e "$blockurls" | sed -e '/^#/d' -e 's:#.*::g' -e 's:^\.::'`; do
    $IPTABLES -A FORWARD -i $LAN -m string --string "$string" --algo kmp -j NFLOG --nflog-prefix 'Domains-Blocklist'
    $IPTABLES -A FORWARD -i $LAN -m string --string "$string" --algo kmp -j DROP
done
```

#### Out NFLOG (/var/log/ulog/syslogemu.log)

```bash
Jul  8 18:42:32 user Domains-Blocklist IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=104.31.216.143 LEN=307 TOS=00 PREC=0x00 TTL=127 ID=18043 DF PROTO=TCP SPT=56342 DPT=443 SEQ=3341743929 ACK=2025788972 WINDOW=16450 ACK PSH FIN URGP=0 MARK=0
Jul  8 18:42:32 user Domains-Blocklist IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=104.20.153.91 LEN=309 TOS=00 PREC=0x00 TTL=127 ID=18046 DF PROTO=TCP SPT=56347 DPT=443 SEQ=1894291045 ACK=3918501014 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:32 user Domains-Blocklist IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=104.20.153.91 LEN=309 TOS=00 PREC=0x00 TTL=127 ID=18047 DF PROTO=TCP SPT=56347 DPT=443 SEQ=1894291045 ACK=3918501014 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:33 user Ultrasurf-HexString IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=94.46.155.193 LEN=281 TOS=00 PREC=0x00 TTL=127 ID=18048 DF PROTO=TCP SPT=56343 DPT=443 SEQ=2920450070 ACK=3653769687 WINDOW=16450 ACK PSH FIN URGP=0 MARK=0
Jul  8 18:42:33 user Domains-Blocklist IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=104.20.153.91 LEN=309 TOS=00 PREC=0x00 TTL=127 ID=18049 DF PROTO=TCP SPT=56347 DPT=443 SEQ=1894291045 ACK=3918501014 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:34 user Ultrasurf-HexString IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=151.139.69.135 LEN=281 TOS=00 PREC=0x00 TTL=127 ID=18050 PROTO=TCP SPT=56346 DPT=443 SEQ=2476213996 ACK=447728801 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:35 user Domains-Blocklist IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=104.20.153.91 LEN=309 TOS=00 PREC=0x00 TTL=127 ID=18053 PROTO=TCP SPT=56347 DPT=443 SEQ=1894291045 ACK=3918501014 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:35 user Ultrasurf-HexString IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=151.139.73.119 LEN=281 TOS=00 PREC=0x00 TTL=127 ID=18055 DF PROTO=TCP SPT=56348 DPT=443 SEQ=3555696871 ACK=3035932859 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  8 18:42:36 user Ultrasurf-HexString IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=151.139.32.110 LEN=281 TOS=00 PREC=0x00 TTL=127 ID=18056 PROTO=TCP SPT=56344 DPT=443 SEQ=473128300 ACK=2213965853 WINDOW=16450 ACK PSH FIN URGP=0 MARK=0
```

#### Important About Block Domains Rule

It is faster to block these domains with a proxy (like [Squid-Cache](http://www.squid-cache.org/). For more information visit [Blackweb](https://github.com/maravento/blackweb)), or with a solution based on dnsmasq, etc. / Es más rápido bloquear estos dominios con un proxy (como [Squid-Cache](http://www.squid-cache.org/). Para mayor información visite [Blackweb](https://github.com/maravento/blackweb)), o con una solución basada en dnsmasq, etc.

### BitTorrent Protocol Rule

```bash
# Lock: BitTorrent Protocol
LOCKBTP=$(curl -s https://gitlab.com/maravento/BlackString/-/raw/master/bittorrent)
for string in `echo -e "$LOCKBTP" | sed -e '/^#/d' -e 's:#.*::g'`; do
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j NFLOG --nflog-prefix 'BitTorrent'
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j DROP
done

```

#### Out NFLOG (/var/log/ulog/syslogemu.log)

```bash
Jul  9 09:36:12 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=172.98.67.7 LEN=116 TOS=00 PREC=0x00 TTL=127 ID=3227 PROTO=UDP SPT=16762 DPT=45371 LEN=96 MARK=0
Jul  9 09:36:12 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=172.98.67.7 LEN=108 TOS=00 PREC=0x00 TTL=127 ID=3228 DF PROTO=TCP SPT=62056 DPT=45371 SEQ=2452061326 ACK=1316214515 WINDOW=16562 ACK PSH URGP=0 MARK=0
Jul  9 09:36:12 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=82.217.81.73 LEN=108 TOS=00 PREC=0x00 TTL=127 ID=3230 DF PROTO=TCP SPT=62054 DPT=40115 SEQ=375153779 ACK=4197543778 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:36:12 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=217.209.151.82 LEN=116 TOS=00 PREC=0x00 TTL=127 ID=3231 PROTO=UDP SPT=16762 DPT=12589 LEN=96 MARK=0
Jul  9 09:36:12 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=217.209.151.82 LEN=108 TOS=00 PREC=0x00 TTL=127 ID=3233 DF PROTO=TCP SPT=62057 DPT=12589 SEQ=1063864017 ACK=2001537619 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:36:13 user BitTorrent IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=172.98.67.7 LEN=108 TOS=00 PREC=0x00 TTL=127 ID=3234 DF PROTO=TCP SPT=62056 DPT=45371 SEQ=2452061326 ACK=1316214515 WINDOW=16562 ACK PSH URGP=0 MARK=0
```

### Brave-Tor Rule

```bash
# Lock: Brave-Tor
LOCKBT=$(curl -s https://gitlab.com/maravento/BlackString/-/raw/master/bravetor)
for string in `echo -e "LOCKBT" | sed -e '/^#/d' -e 's:#.*::g'`; do
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j NFLOG --nflog-prefix 'Brave-Tor'
    $IPTABLES -A FORWARD -i $LAN -m string --hex-string "|$string|" --algo kmp -j DROP
done

```

#### Out NFLOG (/var/log/ulog/syslogemu.log)

```bash
Jul  9 09:53:57 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5068 DF PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:53:58 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5071 DF PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:54:00 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5075 DF PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:54:03 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5077 PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:54:07 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5079 PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
Jul  9 09:54:10 adminred Brave-Tor IN=enp2s1 OUT=enp2s0 MAC=94:18:82:XX:XX:XX:08:00:27:XX:XX:XX:08:00 SRC=192.168.1.27 DST=171.25.193.25 LEN=243 TOS=00 PREC=0x00 TTL=127 ID=5080 DF PROTO=TCP SPT=62143 DPT=443 SEQ=1821560764 ACK=2127432945 WINDOW=16450 ACK PSH URGP=0 MARK=0
```

### Important About Ports (Tor, BitTorrent, etc)

It is recommended to block p2p, tor ports, etc., with [Ipset](https://manpages.debian.org/ipset/ipset.8). For more information visit [Blockports](https://www.maravento.com/2020/06/blackports.html) / Se recomienda bloquear los puertos p2p, tor, etc., con [Ipset](https://manpages.debian.org/ipset/ipset.8). Para mayor información visite el post [Blockports](https://www.maravento.com/2020/06/blackports.html)

```bash
### BLOCKPORTS ###
# Example List: (Remove or add ports to block)
# CHARGEN (19), SSH (22), TELNET (23), 6to4 (41,43,44,58,59,60,3544), FINGER (79), SSDP (2869,1900,5000), RDP-MS WBT Server (3389), RFB-VNC (5900), TOR Ports (8008,8443,9001:9004,9101:9103,9030,9031,9050,9150), SqueezeCenter/Cherokee/Openfire (9090), P2P (4662,4672,6881:6889), DNS over TLS (853), Multicast (5353), SNMP (161), IPP (631)
BP=$(curl -s https://gitlab.com/maravento/gateproxy/-/raw/master/acl/blockports.txt)
# Ipset Rule
$IPSET flush blockports
$IPSET -N -! blockports bitmap:port range 0-65535
for ip in $(echo "$BP"); do
 $IPSET -A blockports $ip
done
for SRCDST in `echo src dst`; do
    $IPTABLES -t mangle -A PREROUTING -m set --match-set blockports $SRCDST -j NFLOG --nflog-prefix 'Blockports'
    $IPTABLES -t mangle -A PREROUTING -m set --match-set blockports $SRCDST -j DROP
    $IPTABLES -A INPUT -m set --match-set blockports $SRCDST -j NFLOG --nflog-prefix 'Blockports'
    $IPTABLES -A INPUT -m set --match-set blockports $SRCDST -j DROP
    $IPTABLES -A FORWARD -m set --match-set blockports $SRCDST -j NFLOG --nflog-prefix 'Blockports'
    $IPTABLES -A FORWARD -m set --match-set blockports $SRCDST -j DROP
    $IPTABLES -A OUTPUT -m set --match-set blockports $SRCDST -j NFLOG --nflog-prefix 'Blockports'
    $IPTABLES -A OUTPUT -m set --match-set blockports $SRCDST -j DROP
done
```

### Important About Source (SRC)

To avoid congestion (of the log and server that manages local network) due to the high level of processing, it is necessary to block local IP address that is generating this traffic. You can do it with [Ipset](https://manpages.debian.org/ipset/ipset.8): / Para evitar la congestión (del log y del servidor que administra la red local) por el alto nivel de procesamiento, es necesario bloquear la dirección IP local que está generando este tráfico. Puede hacerlo con [Ipset](https://manpages.debian.org/ipset/ipset.8):

```bash
#!/bin/bash
### BANIP ###
# example words list:
BLOCKWORDS=$(curl -s https://gitlab.com/maravento/gateproxy/-/raw/master/acl/blockwords.txt)
# path to banip.txt
BIP=/path_to/banip.txt
# ban time (10 min = 600 seconds)
BANTIME="600"
# syslogemu (log)
SYSLOGEMU=/var/log/ulog/syslogemu.log
# localrange (replace "192.168.*" with the first two octets of your local network range)
LOCALRANGE="192.168.*"
# add matches to banip.txt
perl -MDate::Parse -ne "print if/^(.{15})\s/&&str2time(\$1)>time-$BANTIME" $SYSLOGEMU | grep -F "$BLOCKWORDS" | grep -Pio 'src=[^\s]+' | grep -Po $LOCALRANGE > $BIP
# Ipset Rule for BanIP
$IPSET flush banip
$IPSET -N -! banip hash:net maxelem 1000000
for ip in $(cat $BIP); do
    $IPSET -A banip $ip
done
for SRCDST in `echo src dst`; do
    $IPTABLES -t mangle -A PREROUTING -m set --match-set banip $SRCDST -j DROP
    $IPTABLES -A INPUT -m set --match-set banip $SRCDST -j DROP
    $IPTABLES -A FORWARD -m set --match-set banip $SRCDST -j DROP
    $IPTABLES -A OUTPUT -m set --match-set banip $SRCDST -j DROP
done
```

Save the script and schedule it in the crontab to run each 10 min. Adjust the ruler and task time according to your needs. Example: / Guarde el script y prográmelo en el crontab para que se ejecute cada 10 minutos. Ajuste el tiempo de la regla y tarea según sus necesidades. Ejemplo:

```bash
sudo crontab -l | { cat; echo "*/10 * * * * /path_to_script/banip.sh"; } | sudo crontab -
```

### Algorithms Used

- [bm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string-search_algorithm)
- [kmp](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)

## CONTRIBUTIONS

---

We thank all those who have contributed to this project / Agradecemos a todos aquellos que han contribuido a este proyecto

## DONATE

---

BTC: 3M84UKpz8AwwPADiYGQjT9spPKCvbqm4Bc

## BUILD

---

[![CreativeCommons](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)
[maravento.com](http://www.maravento.com) is licensed under a [Creative Commons Reconocimiento-CompartirIgual 4.0 Internacional License](http://creativecommons.org/licenses/by-sa/4.0/).

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
