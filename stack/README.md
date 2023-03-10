# [Stack](https://www.maravento.com)

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)

**Stack** contains installation packages for testing / **Stack** contiene paquetes de instalación para pruebas

## HOW TO USE

---

### For Start

```bash
wget -q -N https://raw.githubusercontent.com/maravento/vault/master/stack/start.sh && sudo chmod +x start.sh && sudo ./start.sh
```

#### Important Before Use Start Script

Incluye los siguientes paquetes:

```bash
# essential
apache samba rsyslog sublime
# tools
nala curl aptitude mlocate net-tools curl software-properties-common apt-transport-https wget ca-certificates geoip-database neofetch ppa-purge gdebi synaptic pm-utils sharutils dpkg pv libnotify-bin inotify-tools expect tcl-expect tree preload xsltproc debconf-utils mokutil uuid-dev libmnl-dev conntrack gcc make autoconf autoconf-archive autogen automake pkg-config deborphan perl lsof finger logrotate linux-firmware util-linux linux-tools-common build-essential module-assistant linux-headers-$(uname -r) git git-gui gitk subversion gist tzdata tar p7zip p7zip-full p7zip-rar rar unrar unzip zip unace cabextract arj zlib1g-dev gawk gir1.2-gtop-2.0 gir1.2-xapp-1.0 javascript-common libjs-jquery libxapp1 rake ruby ruby-did-you-mean ruby-json ruby-minitest ruby-net-telnet ruby-power-assert ruby-test-unit rubygems-integration xapps-common python3-pip libssl-dev libffi-dev python3-dev python3-venv idle3 python3-psutil reiserfsprogs reiser4progs xfsprogs jfsutils dosfstools e2fsprogs hfsprogs hfsutils hfsplus mtools nilfs-tools f2fs-tools gparted libfuse2 nfs-common ntfs-3g exfat-fuse
```

### For LampStack

```bash
wget -q -N https://raw.githubusercontent.com/maravento/vault/master/stack/lampstack.sh && sudo chmod +x lampstack.sh && sudo ./lampstack.sh
```

#### Important Before Use LampStack

- Tested on: / probado en: Ubuntu 20.04/22.04 x64
- Default phpMyAdmin: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
- For LAMP: Default User **root** and Default Password **lampstack** (change it).
- To connect to MySQL Server you must create a new username/password in phpMyAdmin / Para conectar a MySQL Server debe crear un nuevo usuario/password en phpMyAdmin
- LAMP 7.1.33-0 install [MySQL Server v5.7.28, PHP v7.1.33, Apache v2.4.41](https://bitnami.com/stack/lamp/installer/changelog.txt) / LAMP 7.1.33-0 instala [MySQL Server v5.7.28, PHP v7.1.33, Apache v2.4.41](https://bitnami.com/stack/lamp/installer/changelog.txt).
- [Bitnami has discontinued support for most native Linux installers as of June 30, 2021, included LAMP](https://blog.bitnami.com/2021/04/amplifying-our-focus-on-cloud-native.html) / [Bitnami ha descontinuado el soporte para la mayoría de los instaladores nativos para Linux a partir del 30 de junio de 2021](https://blog.bitnami.com/2021/04/amplifying-our-focus-on-cloud-native.html)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
