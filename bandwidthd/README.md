# [BandwidthD](https://www.maravento.com)

[![status-frozen](https://img.shields.io/badge/status-frozen-blue.svg)](https://github.com/maravento/vault/tree/master/bandwidthd)

**BandwidthD** tracks usage of TCP/IP network subnets and builds html files with graphs to display utilization. Charts are built by individual IPs, and by default display utilization over 2 day, 8 day, 40 day, and 400 day periods. Furthermore, each ip address's utilization can be logged out at intervals of 3.3 minutes, 10 minutes, 1 hour or 12 hours in cdf format, or to a backend database server. HTTP, TCP, UDP, ICMP, VPN, and P2P traffic are color coded.

**BandwidthD** rastrea el uso de subredes de red TCP/IP y crea archivos html con gráficos para mostrar la utilización. Los gráficos se crean por IP individuales y, de forma predeterminada, muestran la utilización en períodos de 2 días, 8 días, 40 días y 400 días. Además, la utilización de cada dirección IP puede cerrarse sesión a intervalos de 3,3 minutos, 10 minutos, 1 hora o 12 horas en formato cdf, o en un servidor de base de datos back-end. El tráfico HTTP, TCP, UDP, ICMP, VPN y P2P está codificado por colores.

## DATA SHEET

---

[![status-deprecated](https://img.shields.io/badge/status-deprecated-red.svg)](https://bandwidthd.sourceforge.net/)

| Developers | Last Version | HowTo |
| :---: | :---: | :---: |
| [David Hinkle, Brice Beaman, Andreas Henriksson](https://bandwidthd.sourceforge.net/) | [v2.0.1 (NethServer. 2005)](https://github.com/NethServer/bandwidthd) | [Post (ESP)](https://www.maravento.com/2021/08/bandwidthd.html) |

### Important before using

- This application contains many bugs in the logs, so use it at your own risk. / Esta aplicación contiene muchos bugs en los Logs, por tanto úsela bajo su propio riesgo.
- Tested on: / Probado en: Ubuntu 22.04 LTS x64.

## HOW TO INSTALL

---

```bash
wget -c https://raw.githubusercontent.com/maravento/vault/master/bandwidthd/bwinstall.sh && sudo chmod +x bwinstall.sh && sudo ./bwinstall.sh
```

## HOW TO USE

---

### Access

[http://localhost/bandwidthd/](http://localhost/bandwidthd/)

[![Image](https://raw.githubusercontent.com/maravento/vault/master/bandwidthd/bandwidthd.png)](https://www.maravento.com/)

### Virtualhost

BandwidthD works on port 80 and this can cause conflicts with other applications using this port and the configuration file has no option to change it, so the install script sets up a virtualhost on port 41000. To change it, for example, for 42000 or whatever, run: / BandwidthD trabaja por el puerto 80 y esto puede generar conflictos con otras aplicaciones que usen este puerto y el archivo de configuración no tiene opción para cambiarlo, por tanto, el script de instalación configura un virtualhost en el puerto 41000. Para cambiarlo, por ejemplo, por 42000 o cualquier otro, ejecute:

```bash
sudo sed -i "s:41000:42000:g" /etc/apache2/sites-available/bandwidthd.conf
sudo sed -i "s:41000:42000:g" /etc/apache2/port.conf
```

### Logs

Los logs de BandwidthD se encuentran en la carpeta: / BandwidthD logs are located in the folder:

```bash
/var/lib/bandwidthd/
htdocs  log.1.0.cdf  log.2.0.cdf  log.3.0.cdf log.4.0.cdf
```

And the graphs are located in the htdocs folder and mean the following: / Y las gráficas se encuentran en la carpeta htdocs y significan lo siguiente:

```bash
Daily report = log.1.0.cdf-log.1.5.cdf (htdocs/index.html)
Weekly report = log.2.0.cdf-log.2.5.cdf (htdocs/index2.html)
Monthly report = log.3.0.cdf-log.3.5.cdf (htdocs/index3.html)
Yearly report = log.4.0.cdf-log.4.5.cdf (htdocs/index4.html)
```

#### Log Bugs

The daily graph shows up to 4000 local IP addresses every 200 seconds (3.3 min), updates the report weekly every 10 min, monthly every hour and yearly every 12 hours. However, it is well known that in some scenarios these stats do not do what they are supposed to (check [BandwidthD forum](https://sourceforge.net/p/bandwidthd/discussion/308609/thread/b5f2356a/)). The specific problem is that the logs do not rotate. In fact, they can manually run the script to rotate to no avail. To fix this, the install script creates a task in crontab that sends a `kill` command to `pid` so it can do the rotation, giving it 5 minutes of time to generate statistics (twice as long as the config file says default for graph generation which is 2.5 minutes) and restart the daemon: / El gráfico diario muestra hasta 4000 direcciones IP locales cada 200 segundos (3.3 min), actualiza el reporte el semanal cada 10 min, mensual cada hora y anual cada 12 horas. Sin embargo, es bien conocido que en algunos escenarios estas estadísticas no hacen lo que se supone (ver [foro de BandwidthD](https://sourceforge.net/p/bandwidthd/discussion/308609/thread/b5f2356a/)). El problema concreto es que los log no rotan. De hecho, pueden ejecutar manualmente el script para rotar sin resultados. Para solucionarlo, el script de instalación crea una tarea en crontab que envía un comando `kill` al `pid` para que pueda hacer la rotación, le da 5 minutos de tiempo para generar estadísticas (el doble de tiempo que el archivo de configuración establece por defecto para la generación de gráficas que es 2.5 minutos) y reinicia el demonio:

```bash
0 0 * * * /bin/kill -HUP $(cat /var/run/bandwidthd.pid) && sleep 5m && /etc/init.d/bandwidthd restart
```

It may happen that the log does the rotation, but the graphs are not generated and the daily traffic of the previous day continues to appear, instead of the counter at 0. In this case, the installation script creates another task that solves it, deleting the file rotated, programming the following command in cron: / Puede suceder que el log haga la rotación, pero las gráficas no se generen y siga apareciendo el tráfico diario del día anterior, en lugar del contador a 0. En este caso, el script de instalación crea otra tarea que lo soluciona, eliminando el archivo rotado, programando el siguiente comando en el cron:

```bash
@daily cat /dev/null | tee /var/lib/bandwidthd/log.1.0.cdf && sleep 5m && /etc/init.d/bandwidthd restart
```

To flush all logs, run with privileges: / Para vaciar todos los logs, ejecute con privilegios:

```bash
sudo cat /dev/null | sudo tee /var/lib/bandwidthd/log.* && sudo /etc/init.d/bandwidthd restart
```

### Network Configuration

```bash
sudo bandwidthd -l
```

Example of default ranges from the configuration file: / Ejemplo de rangos por defecto del archivo de configuración:

```bash
sudo cat /etc/bandwidthd/bandwidthd.conf | grep subnet
# matches none of these subnets will be ignored.
#subnet 192.168.0.0/24
subnet 169.254.0.0/16 # LAN
subnet 192.168.0.0/24 # WAN
subnet 192.168.122.0/24 # others interfaces
```

The installation script will ask you to set your network range and mask. You can also do it manually: / El script de instalación le pedirá que establezca su rango de red y máscara. También puede hacerlo manualmente:

```bash
# for LAN
sudo sed -i "s:169.254.0.0/16:192.168.50.0/24:g" /etc/bandwidthd/bandwidthd.conf
# for WAN
sudo sed -i "s:192.168.1.0/16:192.168.0.0/24:g" /etc/bandwidthd/bandwidthd.conf
```

It is suggested not to change "any" in case you have two interfaces you can monitor both: / Se sugiere no cambiar "any" por si tiene dos interfaces pueda monitorear ambas:

```bash
# Device to listen on
# Bandwidthd listens on the first device it detects
# by default.  Run "bandwidthd -l" for a list of
# devices.
#dev "eth0"

dev "any"
```

### Ban Data

This section is to block users who have overcome the consumption of data default by the sysadmin. / Esta sección es para bloquear a los usuarios que hayan superado el consumo de datos predeterminado por el sysadmin.

**To run it manually: / Para ejecutarlo manualmente:**

```bash
sudo /etc/init.d/bwbandata.sh
```

**crontab (every 15 min)**

```bash
*/15 * * * * /etc/init.d/bwbandata.sh
```

**To check the Allowed/Blocked IPs: / Para verificar las IPs Permitidas/Bloqueadas:**

```bash
# Banned IPs
cat /etc/acl/bwbandata.txt
# Allowed IPs
cat /etc/acl/bwallowdata.txt
```

**Replace localnet interface: / Reeplace su interface de red local:**

```bash
sudo nano /etc/init.d/bwbandata.sh

# replace localnet interface (enpXsX)
lan=eth1
```

#### Data Limit

These data quotas (daily or monthly) are expressed in Mbytes or Gbytes (not in Mbps or Gbps which is speed). / Estas cuotas de datos (diaria o mensual) están expresadas en Mbytes o Gbytes (no en Mbps o Gbps que es velocidad).

**To change the daily data limit in `bandata.sh` / Para cambiar el límite de datos diarios en `bandata.sh`:**

```bash
sudo nano /etc/init.d/bwbandata.sh

### BANDATA FOR BANDWIDTHD
# maximum daily data consumption: 1 Gbyte = 1G
max_bandwidth="1G"
```

The nomenclature to use can be in GBytes instead of Bytes, which is more comfortable for the sysadmin, for example 0.5G or 512M or 536870912. By default, we select 1 Gigabyte (GB) of data = 1073741824 byte (B). / La nomenclatura a usar puede ser en GBytes en lugar de Bytes, lo cual es más cómodo para el sysadmin, por ejemplo 0.5G o 512M o 536870912. Por defecto, seleccionamos 1 Gigabyte (GB) de datos = 1073741824 byte (B).

## LICENCES

---

[![GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

© 2023 [Maravento Studio](https://www.maravento.com)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.