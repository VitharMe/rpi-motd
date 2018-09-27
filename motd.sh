#!/bin/bash
docker run --rm -ti vitharme/rpi-motd SERVER
SYSTEM=`uname -a | cut -d "#" -f1`
LASTLOG=`lastlog -u $(whoami) | sed -n 2p | awk '{$2=$2};1'`
D=$(($(cut -d. -f1 /proc/uptime)/60/60/24))
H=$(($(cut -d. -f1 /proc/uptime)/60/60%24))
M=$(($(cut -d. -f1 /proc/uptime)/60%60))
S=$(($(cut -d. -f1 /proc/uptime)%60))
UPTIME="$D days $H hours $M minutes $S seconds"
TEMP=`/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9"`
LOAD=`cat /proc/loadavg`
RT=`free -m | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f2`
RU=`free -m | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f3`
RF=`free -m | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f4`
SU=`free -m | sed -n 3p | awk '{$2=$2};1' | cut -d " " -f3`
DISK=`df -h | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f5`
LOGIN=`who -q | sed -n 2p |cut -c "9-11"`
PSU=`ps h U $(whoami) | wc -l`
PSA=`ps -A h | wc -l`
echo
echo "System........:" $SYSTEM
echo "Last Login....:" $LASTLOG
echo "Uptime........:" $UPTIME
echo "Temperature...:" $TEMP
echo "Load..........:" $LOAD
echo "Memory MB.....:" Total: $RT MB Used: $RU MB Free: $RF SWAP: $SU/99 MB
echo "Disk Usage....:" $DISK
echo "SSH Logins....:" $LOGIN
echo "Processes.....:" $PSU User / $PSA Total
