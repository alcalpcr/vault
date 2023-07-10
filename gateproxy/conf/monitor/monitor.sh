#!/bin/bash
# by maravento.com

cat <<'EOF'
# BandwidthD Service
if [[ $(ps -A | grep bandwidthd) != "" ]];then
    echo -e "\nONLINE"
else
    echo -e "\n"
    for pid in $(ps -ef | grep "bandwidthd" | awk '{print $2}'); do kill -9 $pid &> /dev/null; done
    sleep ${sleep_time}
    /etc/init.d/bandwidthd start
    echo "BandwidthD start: $(date)" | tee --append /var/log/syslog
fi
# NetData Service
if [[ $(ps -A | grep netdata) != "" ]];then
    echo -e "\nONLINE"
else
    echo -e "\n"
    /etc/init.d/netdata stop &> /dev/null
    for pid in $(ps -ef | grep "netdata" | awk '{print $2}'); do kill -9 $pid &> /dev/null; done
    sleep ${sleep_time}
    /etc/init.d/netdata start
    echo "NetData start: $(date)" | tee --append /var/log/syslog
fi
EOF
