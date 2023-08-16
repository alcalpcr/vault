# [Scripts](https://www.maravento.com)

[![status-experimental](https://img.shields.io/badge/status-experimental-orange.svg)](https://github.com/maravento/vault)

Script collection for windows and linux / Colección de script para windows y linux

## GIT CLONE

---

```bash
sudo apt install -y git subversion
svn export "https://github.com/maravento/vault/trunk/scripts"
```

## HOW TO USE

---

### BASH (Linux)

Tested on: / probado en: Ubuntu 20.04/22.04 x64

#### Drive

- [Drive Crypt (Cryptomator Encrypted Disk - Mount | Umount - Folder /home/$USER/DriveCrypt)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/drivecrypt.sh)
- [Gdrive Mount | Umount (folder /home/$USER/Gdrive)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/gdrive.sh)

#### Net

- [Check Bandwidth](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/bandwidth.sh)
- [IP Kill](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/ipkill.sh)
- [Net Report](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/netreport.sh)
- [Port Kill (check port with: `sudo netstat -lnp | grep "port"`)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/portkill.sh)

#### SysTools

- [ARP table filter](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/arponscan.sh)
- [Check Cron](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/checkcron.sh)
- [Disk Temp (HDD/SSD/NVMe)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/disktemp.sh)
- [FreeFileSync Update](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/ffsupdate.sh)
- [Kill Process By Name](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/pskill.sh)
- [Kworker Kill](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/kworker.sh)
- [TRIM (SSD/NVMe)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/trim.sh)

#### Virtual

- [phpVirtualBox install](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/phpvbox.sh)
- [Virtual Hard Disk (VHD) image (.img) with loop or kpartx - Create and Mount | Umount](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/vdisk.sh)
- [VirtualBox Install | Remove](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/vboxinstall.sh)
- [VMs Virtualbox {start|stop|shutdown|reset|status} (replace `my_vm` with the name of your vm)](https://raw.githubusercontent.com/maravento/vault/master/scripts/bash/vm.sh)

### BATCH (Windows)

Tested on: / probado en: Windows 7/10/11 x64 (run with privileges)

- [Activate or Deactivate SMB signing](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/smbsign.bat)
- [Activate or Deactivate SMB1 protocol](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/smb1.bat)
- [Force reset proxy and network interfaces](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/netreset.bat)
- [Run PC in mode: safe with network/safe minimal/normal](https://raw.githubusercontent.com/maravento/vault/master/scripts/batch/safemode.bat)

## LICENSES

---

[![GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.txt)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

© 2023 [Maravento Studio](https://www.maravento.com)

## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
