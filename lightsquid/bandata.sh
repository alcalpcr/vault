#!/bin/bash
# by maravento.com

# Bandata for LightSquid
# Data Plan for LocalNet
# https://www.maravento.com/2022/10/lightsquid.html

# Instructions:
# Default: max 1G (GBytes) daily / 30G (GBytes) month
# Adjust the variable "max_bandwidth_*", according to your needs
# Can use fractions of bandwidth. Eg: 0.3G, 1.0G, 2.9G etc
# Can use M (MBytes) or G (GBytes). Eg: 50M, 1G etc
# bandata excludes weekends

# checking root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi
# checking script execution
if pidof -x $(basename $0) >/dev/null; then
  for p in $(pidof -x $(basename $0)); do
    if [ "$p" -ne $$ ]; then
      echo "Script $0 is already running..."
      exit
    fi
  done
fi

### GLOBAL
# ipset/iptables
iptables=/sbin/iptables
ipset=/sbin/ipset
# reorganize IP
reorganize="sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n"
# replace localnet interface (enpXsX)
lan=eth1

### ACLs
# path to reports
report=/var/www/lightsquid/report
# path to ACLs folder
aclroute=/etc/acl
# Create folder if doesn't exist
if [ ! -d $aclroute ]; then mkdir -p $aclroute; fi &>/dev/null
# path to ACLs files
allow_list=$aclroute/allowdata.txt
block_list_daily=$aclroute/bandaily.txt
block_list_month=$aclroute/banmonth.txt
# Create ACLs files if doesn't exist
if [[ ! -f {$allow_list,$block_list_daily,$block_list_month} ]]; then touch {$allow_list,$block_list_daily,$block_list_month}; fi

### BANDATA FOR LIGHTSQUID: DAILY
# Maximum daily data consumption: 1 Gbyte = 1073741824 Bytes | 0.5 Gigabytes = 536870912 Bytes
# onlive converter tool: https://convertlive.com/c/convert/data-size
max_bandwidth_daily="1G"
max_bw=$(echo $max_bandwidth_daily | tr '.' ',' | numfmt --from=iec)
# path to daily report
daily_logs=$report/$(date +"%Y%m%d")
# today
today=$(date +"%u")
# bandata daily rule
echo "Running Bandata Daily..."
if [[ "$today" -eq 6 || "$today" -eq 7 ]]; then
  echo "Weekend Excluded"
  cat /dev/null >$block_list_daily
else
  echo "Not Weekend"
  (
    cd $daily_logs
    for file in 192.168*; do
      if (($(awk <$file '/^total/ {print($2)}') > $max_bw)); then
        echo $file
      fi
    done
  ) >banout
  cat banout | grep -wvf $allow_list >$block_list_daily
fi
echo "OK"

### BANDATA FOR LIGHTSQUID: MONTH
# Maximum month data consumption: : 30 Gbyte = 32212254720 Bytes
max_bandwidth_month="30G"
max_bw=$(echo $max_bandwidth_month | tr '.' ',' | numfmt --from=iec)
# path to month report
month_logs=$report/$(date +"%Y%m"*)
weekend_logs=$(
  for x in $(seq 0 9); do
    date -d "$x sun 5 week ago" +'%b %Y%m%d'
    date -d "$x sat 5 week ago" +'%b %Y%m%d'
  done | grep $(date +%b) | awk '{print $2}'
)
folders=$(find $month_logs -type f | grep -vf <(echo "$weekend_logs"))
totals=$(echo "$folders" | xargs -I {} awk '/^total:/{sub(".*/", "", FILENAME); print FILENAME" "$NF}' {})
ips=$(echo "$totals" | awk '{ arr[$1]+=$2 } END { for (key in arr) printf("%s\t%s\n", arr[key], key) }' | sort -k1,1)
# bandata monthly rule
echo "Running Bandata Monthly..."
echo "$ips" | awk '$1 > '$max_bw' {print $2}' | grep -wvf $allow_list >$block_list_month
echo "OK"

### IPSET/IPTABLES FOR BANDATA
echo "Running Ipset/Iptables Rules..."
$ipset -L bandata >/dev/null 2>&1
if [ $? -ne 0 ]; then
  $ipset -! create bandata hash:net family inet hashsize 1024 maxelem 65536
else
  $ipset -! flush bandata
fi
for ip in $(cat $block_list_daily $block_list_month | $reorganize | uniq); do
  $ipset -! add bandata "$ip"
done
$iptables -t mangle -I PREROUTING -i $lan -m set --match-set bandata src,dst -j DROP
$iptables -I INPUT -i $lan -m set --match-set bandata src,dst -j DROP
$iptables -I FORWARD -i $lan -m set --match-set bandata src,dst -j DROP
echo "Done"
