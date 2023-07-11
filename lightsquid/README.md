# [Lightsquid](https://www.maravento.com)

[![status-frozen](https://img.shields.io/badge/status-frozen-blue.svg)](https://github.com/maravento/vault/tree/master/lightsquid)

**Lightsquid** is a webapp that works exclusively with [Squid-Cache](https://www.squid-cache.org/), extracting from `access.log` the necessary data to show the traffic statistics of the local network.

**Lightsquid** es una webapp que trabaja exclusivamente con [Squid-Cache](https://www.squid-cache.org/), extrayendo de `access.log` los datos necesarios para mostrar las estadísticas del tráfico de la red local.

## DATA SHEET

---

[![status-deprecated](https://img.shields.io/badge/status-deprecated-red.svg)](https://lightsquid.sourceforge.net/)

| Developer | Fork | Theme | HowTo |
| :---: | :---: | :---: | :---: |
| [v1.8-7 (2009)](https://lightsquid.sourceforge.net/) | [v1.8.1 (2021)](https://github.com/finisky/lightsquid-1.8.1) | [Metro (2020)](https://www.sysadminsdecuba.com/2020/09/lightsquid/) | [Post (ESP)](https://www.maravento.com/2022/10/lightsquid.html) |

### Important before using

- This project is a fork of [v1.8.1](https://github.com/finisky/lightsquid-1.8.1), updated with [fixes](https://github.com/finisky/lightsquid-1.8.1/issues/1) / Este proyecto es un fork de [v1.8.1](https://github.com/finisky/lightsquid-1.8.1), actualizado con [correcciones](https://github.com/finisky/lightsquid-1.8.1/issues/1).
- If any IP addresses on your local network do not go through the Squid proxy, then they will not appear in the reports. / Si alguna dirección IP de su red local no pasan por el proxy Squid, entonces no aparecerá en los reportes.
- Tested on: / Probado en: Ubuntu 22.04 LTS x64.

## HOW TO INSTALL

---

```bash
wget -c https://raw.githubusercontent.com/maravento/vault/master/lightsquid/lsinstall.sh && sudo chmod +x lsinstall.sh && sudo ./lsinstall.sh
```

## HOW TO USE

---

### Access

[http://localhost/lightsquid/index.cgi](http://localhost/lightsquid/index.cgi)

[![Image](https://raw.githubusercontent.com/maravento/vault/master/lightsquid/lightsquid.png)](https://www.maravento.com/)

### Crontab

The LightSquid install script runs a command that by default schedules the crontab to run lightsquid every 10 seconds and bandata every 12 seconds. You can adjust it according to your preferences. / El script de instalación de LightSquid ejecuta un comando que programa por defecto en el crontab la ejecución de lightsquid cada 10 segundos y de bandata cada 12 segundos. Puede ajustarlo según sus preferencias.

```bash
*/10 * * * * /var/www/lightsquid/lightparser.pl today
*/12 * * * * /etc/init.d/bandata.sh"
```

### Scan Users

To scan your users, choose your network range. e.g.: / Para escanear sus usuarios, elija su rango de red. ej:

```bash
sudo nbtscan 192.168.1.0/24
```

### Parameters

**To run it for the first time: / Para ejecutarlo por primera vez:**

```bash
sudo /var/www/lightsquid/lightparser.pl
```

**To run it manually: / Para ejecutarlo manualmente:**

To run the script manually: / Para ejecutar el script manualmente:

```bash
sudo /var/www/lightsquid/lightparser.pl today
```

**To add users: / Para agregar usuarios:**

```bash
sudo nano /var/www/lightsquid/realname.cfg
# example:
192.168.1.2 Client1
192.168.1.3 CEO
```

**To exclude users: / Para excluir usuarios:**

```bash
sudo nano /var/www/lightsquid/skipuser.cfg
# example
192.168.1.1
```

**To modify the default theme Metro: / Para modificar el tema por defecto Metro:**

```bash
sudo nano /var/www/lightsquid/lightsquid.cfg
# choose theme (default "metro")
#$templatename        ="base";
$templatename        ="metro_tpl";
```

### Ban Data

This section is to block users who have overcome the consumption of data default by the sysadmin. / Esta sección es para bloquear a los usuarios que hayan superado el consumo de datos predeterminado por el sysadmin.

**To run it manually: / Para ejecutarlo manualmente:**

```bash
sudo /etc/init.d/bandata.sh
```

**Replace localnet interface: / Reeplace su interface de red local:**

```bash
sudo nano /etc/init.d/bandata.sh
# replace localnet interface (enpXsX)
lan=eth1
```

**To check the banned IPs: / Para verificar las IPs baneadas:**

```bash
cat /etc/acl/{banmonth,bandaily}.txt | uniq
```

#### Data Limit

If you modify the default values of the data consumption assigned to each user (daily and monthly) in the `bandata.sh` script, you must also do so in `lightsquid.cfg`. Additionally, it is necessary to clarify that these data quotas (daily or monthly) are expressed in Mbytes or Gbytes (not in Mbps or Gbps which is speed). / Si modifica los valores por defecto del consumo de datos asignado a cada usuario (diario y mensual) en el script `bandata.sh`, también deberá hacerlo en `lightsquid.cfg`. Adicionalmente, es necesario aclarar que estas cuotas de datos (diaria o mensual) están expresadas en Mbytes o Gbytes (no en Mbps o Gbps que es velocidad).

**To change the daily data limit in `bandata.sh` / Para cambiar el límite de datos diarios en `bandata.sh`:**

```bash
max_bandwidth_daily="1G"
```

The nomenclature to use can be in GBytes instead of Bytes, which is more comfortable for the sysadmin, for example 0.5G or 512M or 536870912. By default, we select 1 Gigabyte (GB) of data = 1073741824 byte (B). / La nomenclatura a usar puede ser en GBytes en lugar de Bytes, lo cual es más cómodo para el sysadmin, por ejemplo 0.5G o 512M o 536870912. Por defecto, seleccionamos 1 Gigabyte (GB) de datos = 1073741824 byte (B).

**To change the monthly data limit in `bandata.sh` / Para cambiar el límite de datos mensual en `bandata.sh`:**

```bash
max_bandwidth_month="30G"
```

**To change the data limit in `lightsquid.cfg` / Para cambiar el límite de datos en `lightsquid.cfg`:**

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

### Reports (Optional)

LightSquid can generate reports in PDF, CSV, etc., but it will only show the TOP domains. If you want all visited domains on your local network in a single ACL, suitable for Squid, run the following command: / LightSquid puede generar reportes en PDF, CSV, etc., pero solo mostrará los dominios TOP. Si quiere todos los dominios visitados de su red local en una sola ACL, apta para Squid, ejecute el siguiente comando:

```bash
find /var/www/lightsquid/report -type f -name '[0-9]*.[0-9]*.[0-9]*.[0-9]*' -exec grep -oE '[[:alnum:]_.-]+\.([[:alnum:]_.-]+)+' {} \; | sed 's/^\.//' | sed -r 's/^(www|ftp|ftps|ftpes|sftp|pop|pop3|smtp|imap|http|https)\.//g' | sed -r '/^[0-9]{1,3}(\.[0-9]{1,3}){3}$/d' | tr -d ' ' | awk '{print "." $1}' | sort -u > sites.txt
```

## LICENCES

---

[![GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

© 2023 [Maravento Studio](https://www.maravento.com)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
