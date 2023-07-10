#!/bin/bash
# by maravento.com

# BANDATA FOR BANDWIDTHD
# Data Plan for LocalNet
# https://www.maravento.com/2021/08/bandwidthd.html
# maximum daily data consumption: 1 Gbyte = 1G
# adjust the variable "max_bandwidth", according to your needs
# can use fractions of bandwidth. Eg: 1.2G, 3.9G...

# checking root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
# checking script execution
if pidof -x $(basename $0) > /dev/null; then
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
# replace localnet interface (enpXsX)
lan=eth1

### ACLs
# path to ACLs folder
aclroute=/etc/acl
# path to ACLs
allow_list=$aclroute/allowdata.txt
block_list=$aclroute/bandata_bw.txt
# Create ACLs if doesn't exist
if [[ ! -f {$allow_list,$block_list} ]]; then touch {$allow_list,$block_list}; fi

### DEBUG IP
reorganize="sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n -k 5,5n -k 6,6n -k 7,7n -k 8,8n -k 9,9n"

### BANDATA FOR BANDWIDTHD
# maximum daily data consumption: 1 Gbyte = 1G
max_bandwidth="1G"
# path daily report
html_file=/var/lib/bandwidthd/htdocs/index.html
# capture
ips=$(grep -Pi '\<tr\.*' $html_file | sed -r 's:<[^>]+>: :g' | grep 192.168.1 | awk '{gsub(/\./, ",", $2); print $2" "$1}')
max_bw=$(echo $max_bandwidth | tr '.' ',' | numfmt --from=iec)
echo "$ips" | numfmt --from=iec | awk '$1 > '$max_bw' {print $2}' | grep -wvf $allow_list > $block_list

### IPSET/IPTABLES FOR BANDATA
$ipset -L bandatabw >/dev/null 2>&1
if [ $? -ne 0 ]; then
        $ipset -! create bandatabw hash:net family inet hashsize 1024 maxelem 65536
    else
        $ipset -! flush bandatabw
fi
for ip in $(cat $block_list | $reorganize | uniq); do
    $ipset -! add bandatabw "$ip"
done
$iptables -t mangle -I PREROUTING -i $lan -m set --match-set bandatabw src,dst -j DROP
$iptables -I INPUT -i $lan -m set --match-set bandatabw src,dst -j DROP
$iptables -I FORWARD -i $lan -m set --match-set bandatabw src,dst -j DROP
echo Done
