# GDiskDump

GUI for diskdump (dd). Harddrive clone and image Tool. The Program is written in Python and uses GTK+. Licence: GNU GPL v2. This is a open source Graphical User Interface for the Unix Command dd. You can easily select the Input- and Outputstream, so you can clone or image your Harddrive or Partition.

## DATA SHEET

---

- GDiskDump v0.8-1 (source code and deb)

### How To Install

1. Create a bash script

```bash
#!/usr/bin/env bash
# PATH_TO_DEPENDENCIES (Change it to the directory of your preference)
gdiskdumprepo=$(pwd)/gdiskdumprepo
if [ ! -d "$gdiskdumprepo" ]; then mkdir -p "$gdiskdumprepo"; fi
pkgs='libgnome-keyring-common libgnome-keyring0 libgksu2-0 gksu python-gtk2 python-notify gdiskdump'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
    cat dependencies.txt | xargs -n 1 -P 2 wget -q -nc -P "$gdiskdumprepo"
    # Install gdiskdump
    cd "$gdiskdumprepo"
    dpkg --force-depends -i *
    apt-get -y install -f
fi
```
2. File `dependencies.txt`

```bash
# libgnome-keyring-common
https://old-releases.ubuntu.com/ubuntu/pool/universe/libg/libgnome-keyring/libgnome-keyring-common_3.12.0-1build1_all.deb
# libgnome-keyring0
https://old-releases.ubuntu.com/ubuntu/pool/universe/libg/libgnome-keyring/libgnome-keyring0_3.12.0-1build1_amd64.deb
# libgksu2-0
http://old-releases.ubuntu.com/ubuntu/pool/universe/libg/libgksu/libgksu2-0_2.0.13~pre1-9ubuntu2_amd64.deb
# gksu
http://old-releases.ubuntu.com/ubuntu/pool/universe/g/gksu/gksu_2.0.2-9ubuntu1_amd64.deb
# python-gtk2
https://old-releases.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-5.1ubuntu2_amd64.deb
# python-notify
http://deb.debian.org/debian/pool/main/n/notify-python/python-notify_0.1.1-4_amd64.deb
# gdiskdump
https://launchpad.net/gdiskdump/trunk/0.8/+download/gdiskdump_0.8-1_all.deb
```

### How to Use

<img src="https://1.bp.blogspot.com/-mBBNI4ASojQ/YPXUiAop8oI/AAAAAAAARjI/7YiS2fXb7lM6b-AaKrCa5Sf1RmAmVWNXQCLcBGAsYHQ/s0/gdiskdump.png" width="300" hspace="2"/> <img src="https://1.bp.blogspot.com/-RktrAK5d9n8/YPXUih0sPQI/AAAAAAAARjM/ddad1Umrb7EYfVRGKRANWYQII61BhcIjgCLcBGAsYHQ/s0/gdiskdump2.png" width="300" hspace="2"/>

### Original Project

| Developer | Last Update | Source | 
| :---: | :---: | :---: |
| [screenfreeze](http://screenfreeze.net/about/) | 0.8 (2012) | [code](https://gitlab.com/maravento/vault/-/tree/master/linux/gdiskdump)

### Important

- This project is deprecated. Status: Abandoned / Este proyecto está obsoleto. Estado: Abandonado

### References

- [Launchpad](https://launchpad.net/gdiskdump/+download)
- [screenfreeze](http://screenfreeze.net/gdiskdump-on-github/)


## DISCLAIMER

---

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
