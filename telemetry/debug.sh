#!/bin/bash
### BEGIN INIT INFO
# Provides:          debug
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Should-Start:      $named
# Should-Stop:       $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon
### END INIT INFO

# VARIABLES
debug=$(pwd)/debug
date=`date +%d/%m/%Y" "%H:%M:%S`
regexd='([a-zA-Z0-9][a-zA-Z0-9-]{1,61}\.){1,}(\.?[a-zA-Z]{2,}){1,}'
wgetd="wget -c --retry-connrefused -t 0"
xdesktop=$(xdg-user-dir DESKTOP)

# DELETE OLD REPOSITORY AND CREATE NEW
if [ -d $debug ]; then rm -rf $debug; fi
mkdir $debug && cd $debug

# DOWNLOAD
function urls() {
	$wgetd "$1" -O - >> updateurls.txt
}
	urls 'https://gist.githubusercontent.com/changeme/a2e6aa686303eb47f3dc9f830fdae703/raw/24af43dd0fa9f920f10cdd5d2b3e74060596bf21/Mikrotik%2520-%2520Microsoft%2520telemetry%2520block' && sleep 1
	urls 'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt' && sleep 1
	urls 'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt' && sleep 1
	urls 'https://raw.githubusercontent.com/AlexanderOnischuk/DeleteTelemetryWin10/master/DeleteTelemetryWin10.bat' && sleep 1
	urls 'https://raw.githubusercontent.com/beerisgood/Windows10_Anti-Telemetry/master/Stop%20Microsoft%20spying%20with%20Windows%20Firewall' && sleep 1
	urls 'https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt' && sleep 1
	urls 'https://raw.githubusercontent.com/Forsaked/hosts/master/hosts' && sleep 1
	urls 'https://raw.githubusercontent.com/j-42/hosts/master/hosts' && sleep 1
	urls 'https://raw.githubusercontent.com/kevle2/BlocklistWindowsTelemetry/master/Blocklist.txt' && sleep 1
	urls 'https://raw.githubusercontent.com/maravento/blackweb/master/bwupdate/telemetryurls.txt' && sleep 1
	urls 'https://raw.githubusercontent.com/root-host/Windows-Telemetry/master/domains3' && sleep 1
	urls 'https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.2o7Net/hosts' && sleep 1
	urls 'https://raw.githubusercontent.com/Strappazzon/teleme7ry/master/teleme7ry.bat' && sleep 1
	urls 'https://raw.githubusercontent.com/szotsaki/windows-telemetry-removal/master/WindowsTelemetryRemoval.bat' && sleep 1
	urls 'https://raw.githubusercontent.com/W4RH4WK/Debloat-Windows-10/master/scripts/block-telemetry.ps1' && sleep 1
	urls 'https://v.firebog.net/hosts/Airelle-trc.txt' && sleep 1
	urls 'https://v.firebog.net/hosts/Easyprivacy.txt' && sleep 1
	urls 'https://v.firebog.net/hosts/Prigent-Ads.txt' && sleep 1

# CAPTURING TELEMETRY DOMAINS
cd ..
find $debug -type f -execdir grep -oiE "$regexd" {} \; | sed '/[A-Z]/d' | sed '/0--/d' | sed -r '/[^a-zA-Z0-9.-]/d' | sed -r 's:(^\.*?(www|ftp|xxx|wvw)[^.]*?\.|^\.\.?)::gi' | awk '{print "."$1}' | sed -r '/^\.\W+/d' | sed -r 's:^\.(.*):0.0.0.0 \1:' | sort -u > tnt.txt
rm -rf $debug
echo "Done"
