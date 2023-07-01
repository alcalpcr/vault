# [Lightsquid](https://www.maravento.com)

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)

**Lightsquid** is a webapp that works exclusively with [Squid-Cache](https://www.squid-cache.org/), extracting from `access.log` the necessary data to show traffic statistics. Therefore, if some IP addresses on your local network do not go through the Squid, then they will not appear in the reports. / **Lightsquid** es una webapp que trabaja exclusivamente con [Squid-Cache](https://www.squid-cache.org/), extrayendo de `access.log` los datos necesarios para mostrar las estadísticas del tráfico. Por lo anterior, si algunas direcciones IP de su red local no pasan por el Squid, entonces no aparecerán en los reportes.

## HOW TO USE

---

[![Image](https://raw.githubusercontent.com/maravento/vault/master/lightsquid/lightsquid.png)](https://www.maravento.com/)

### HowTo

[Lightsquid - HowTo - v1.8.1](https://www.maravento.com/2022/10/lightsquid.html)

### Dependencies

```bash
pkgs='wget git tar squid apache2 ipset'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  apt-get install $pkgs
fi
```

### Install

```bash
sudo apt install -y libcgi-session-perl libgd-gd2-perl
git clone --depth=1 https://github.com/maravento/vault/master/lightsquid.git
cd lightsquid
sudo chmod +x lightsquid.sh
sudo ./lightsquid.sh
```

### Access

http://localhost/lightsquid/

### Scan Users (Optional)

Choose your private network range: / Elija su rango de red privada:

```bash
sudo apt-get install nbtscan
sudo nbtscan 192.168.1.0/24
```

### LightSquid Parameters

To run it for the first time: / Para ejecutarlo por primera vez:

```bash
sudo /var/www/lightsquid/lightparser.pl
```

**To run it manually: / Para ejecutarlo manualmente:**

The script is already set in your crontab to run every 10 seconds. To run the script manually: / El script ya está configurado en su crontab para ejecutarse cada 10 segundos. Para ejecutar el script manualmente:

```bash
sudo /var/www/lightsquid/lightparser.pl today
```

**To add users: / Para agregar usuarios:**

```bash
sudo nano /var/www/lightsquid/realname.cfg
# example:
192.168.1.2	Client1
192.168.1.3	CEO
```

**To exclude users: / Para excluir usuarios:**

```bash
sudo nano /var/www/lightsquid/skipuser.cfg
# example
192.168.1.1
```

**To change the data limit: / Para cambiar el límite de datos:**

```bash
sudo nano /var/www/lightsquid/lightsquid.cfg
```

And modify the following line: / Y modificar la siguiente línea:

```bash
#user maximum size per day limit (oversize)
$perusertrafficlimit = 10*1024*1024;
```

By default it comes in 10, which means 10 Mbytes, so for 512 Mbytes they would be 512 and 1 Gbytes would be 1000: / Por defecto viene en 10, que significa 10 Mbytes, por tanto para 512 Mbytes serían 512 y 1 Gbytes serían 1000:

```bash
#user maximum size per day limit (oversize)
$perusertrafficlimit = 1000*1024*1024;
```

**To modify the default theme: / Para modificar el tema por defecto:**

```bash
sudo nano /var/www/lightsquid/lightsquid.cfg
# choose theme (default "metro")
#$templatename        ="base";
$templatename        ="metro_tpl";
```

### BanData Parameters

The script is already set in your crontab to run every 12 seconds. To run the script manually: / El script ya está configurado en su crontab para ejecutarse cada 12 segundos. Para ejecutar el script manualmente:

```bash
sudo /etc/init.d/bandata.sh
```

**To check the banned IPs: / Para verificar las IPs baneadas:**

```bash
# path to ACLs folder by default
aclroute=/etc/acl
# path to ACLs files
allow_list=$aclroute/allowdata.txt
block_list_daily=$aclroute/bandaily.txt
block_list_month=$aclroute/banmonth.txt
cat /$aclroute/{banmonth,bandaily}.txt | uniq"
```

**To increase or decrease the daily data for each user: / Para aumentar o disminuir los datos diarios a cada usuario:**

```bash
max_bandwidth_daily="1G"
```

The nomenclature to use can be in GBytes instead of Bytes, which is more comfortable for the sysadmin, for example 0.5G or 512M or 536870912. By default, we select 1 Gigabyte (GB) of data = 1073741824 byte (B). / La nomenclatura a usar puede ser en GBytes en lugar de Bytes, lo cual es más cómodo para el sysadmin, por ejemplo 0.5G o 512M o 536870912. Por defecto, seleccionamos 1 Gigabyte (GB) de datos = 1073741824 byte (B).

**To increase or decrease the monthly data for each user: / Para aumentar o disminuir los datos mensuales a cada usuario:**

```bash
max_bandwidth_month="30G"
```

**Important**: These data quotas (daily or monthly) are expressed in Mbytes or Gbytes (not in Mbps or Gbps which is speed) / Estas cuotas de datos (diaria o mensual) están expresadas en Mbytes o Gbytes (no en Mbps o Gbps que es velocidad)

### Virtualhost Parameters

Edit: / Edite:

```bash
sudo nano /etc/apache2/conf-available/lightsquid.conf
```

And modify the field: / Y modificar el campo: `Require ip 192.168.1.0/24`

```bash
Alias /lightsquid/ /var/www/lightsquid/
   <Location "/lightsquid/">
   Options +ExecCGI
   AddHandler cgi-script .cgi .pl
   Require local
   # replace the IP address and mask with that of your local network
   Require ip 192.168.1.0/24
</Location>
```

### Reports

LightSquid can generate reports in PDF, CSV, etc., but it will only show the TOP domains. If you want all visited domains on your local network in a single ACL, suitable for Squid debugging, run the following command: / LightSquid puede generar reportes en PDF, CSV, etc., pero solo mostrará los dominios TOP. Si quiere todos los dominios visitados de su red local en una sola ACL, apta para depuración Squid, ejecute el siguiente comando:

```bash
find /var/www/lightsquid/report -type f -name '[0-9]*.[0-9]*.[0-9]*.[0-9]*' -exec grep -oE '[[:alnum:]_.-]+\.([[:alnum:]_.-]+)+' {} \; | sed 's/^\.//' | sed -r 's/^(www|ftp|ftps|ftpes|sftp|pop|pop3|smtp|imap|http|https)\.//g' | sed -r '/^[0-9]{1,3}(\.[0-9]{1,3}){3}$/d' | tr -d ' ' | awk '{print "." $1}' | sort -u > sites.txt
```

## Source

- [Lightsquid - Original Repo v1.8-7](https://lightsquid.sourceforge.net/)
- [LightSquid - Update v1.8.1](https://github.com/finisky/lightsquid-1.8.1)
- [LightSquid - Metro Theme](https://www.sysadminsdecuba.com/2020/09/lightsquid/)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
