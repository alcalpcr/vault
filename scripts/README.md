# [Scripts](https://www.maravento.com)

[![status-beta](https://img.shields.io/badge/status-beta-magenta.svg)](https://github.com/maravento/vault/tree/master/scripts)

Script collection for windows and linux / Colección de script para windows y linux

## HOW TO USE

---

### Bash (Linux)

Tested on: / probado en: Ubuntu 20.04/22.04 x64

- FreeFileSync Update

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/ffsupdate.sh && sudo chmod +x ffsupdate.sh && sudo ./ffsupdate.sh
  ```

- IP Kill

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/ipkill.sh && sudo chmod +x ipkill.sh && sudo ./ipkill.sh
  ```

- Port Kill (check port with: `sudo netstat -lnp | grep "port"`)

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/portkill.sh && sudo chmod +x portkill.sh && sudo ./portkill.sh
  ```

- Kill Process By Name

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/pskill.sh && sudo chmod +x pskill.sh && sudo ./pskill.sh
  ```

- VirtualBox install | remove

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/vbox.sh && sudo chmod +x vbox.sh && sudo ./vbox.sh
  ```

- VMs Virtualbox {start|stop|shutdown|reset|status} (replace `my_vm` with the name of your vm)

  ```bash
  wget -q -N https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/vm.sh && sudo chmod +x vm.sh && sudo ./vm.sh start
  ```

### Batch (Windows)

Tested on: / probado en: Windows 7/10/11 x64 (run with privileges)

- Force reset proxy and network interfaces

  [netreset](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/netreset.bat)

- Run PC in mode: safe with network/safe minimal/normal

  [safemode](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/safemode.bat)

- Activate or Deactivate SMB1 protocol

  [smb1](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/smb1.bat)

## LICENCES

---

[![GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

© 2023 [Maravento Studio](https://www.maravento.com)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
