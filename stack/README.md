# [Stack](https://www.maravento.com)

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)

**Stack** contains stack installation package for linux / **Stack** contiene paquete de instalación stack para Linux

## HOW TO USE

---

### For LampStack

```bash
wget -q -N https://raw.githubusercontent.com/maravento/vault/master/stack/lampstack.sh && sudo chmod +x lampstack.sh && sudo ./lampstack.sh
```

#### Important Before Use LampStack

- Tested on: / probado en: Ubuntu 20.04/22.04 x64
- Default phpMyAdmin: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
- For LAMP: Default User **root** and Default Password **lampstack** (change it).
- To connect to MySQL Server you must create a new username/password in phpMyAdmin / Para conectar a MySQL Server debe crear un nuevo usuario/password en phpMyAdmin
- LAMP 7.1.33-0 is the latest released version of the Bitnami Stack for Linux with MySQL 5.7.x. Contains [MySQL Server v5.7.28, PHP v7.1.33, Apache v2.4.41](https://bitnami.com/stack/lamp/installer/changelog.txt) / LAMP 7.1.33-0 es la última versión lanzada de Bitnami Stack para Linux con MySQL 5.7.x. Contiene [MySQL Server v5.7.28, PHP v7.1.33, Apache v2.4.41](https://bitnami.com/stack/lamp/installer/changelog.txt).
- [Bitnami has discontinued support for most native Linux installers as of June 30, 2021](https://blog.bitnami.com/2021/04/amplifying-our-focus-on-cloud-native.html) / [Bitnami ha descontinuado el soporte para la mayoría de los instaladores nativos para Linux a partir del 30 de junio de 2021](https://blog.bitnami.com/2021/04/amplifying-our-focus-on-cloud-native.html)
- To update MySQL you can download it [HERE](https://dev.mysql.com/downloads/mysql/5.7.html#downloads/) / Para actualizar MySQL puede descargarlo [AQUI](https://dev.mysql.com/downloads/mysql/5.7.html#downloads/)

#### To Remove LampStack

```bash
sudo /opt/bitnami/uninstall
```

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
