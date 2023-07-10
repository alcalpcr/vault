#!/bin/bash
### BEGIN INIT INFO
# Provides:         ddos
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts ddos uninstall
# Description:       starts ddos using start-stop-daemon
### END INIT INFO

echo; echo "Uninstalling DOS-Deflate"
echo; echo; echo -n "Deleting script files....."
if [ -e '/usr/local/sbin/ddos' ]; then
    rm -f /usr/local/sbin/ddos
    echo -n ".."
fi
if [ -d '/usr/local/ddos' ]; then
    rm -rf /usr/local/ddos
    echo -n ".."
fi
echo "done"
echo; echo -n "Deleting cron job....."
if [ -e '/etc/cron.d/ddos.cron' ]; then
    rm -f /etc/cron.d/ddos.cron
    echo -n ".."
fi
echo "done"
echo; echo "Uninstall Complete"; echo
