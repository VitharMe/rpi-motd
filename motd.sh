#!/bin/bash
docker run --rm -ti vitharme/rpi-motd ./text.sh SERVER
SYSTEM=`uname -a | cut -d "#" -f1`
LASTLOG=`lastlog -u $(whoami) | sed -n 2p | awk '{$2=$2};1'`
D=$(($(cut -d. -f1 /proc/uptime)/60/60/24))
H=$(($(cut -d. -f1 /proc/uptime)/60/60%24))
M=$(($(cut -d. -f1 /proc/uptime)/60%60))
S=$(($(cut -d. -f1 /proc/uptime)%60))
GREEN="\e[38;5;118m"
YELLOW="\e[38;5;226m"
RED="\e[38;5;196m"
UPTIME="$D days $H hours $M minutes $S seconds"
TEMP=`/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9"`
COMPARETEMP=`/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9" | cut -d "." -f1`
if [ $COMPARETEMP -le 50 ]; then
	CTEMP=$GREEN
elif [ $COMPARETEMP -le 55 ]; then
	CTEMP=$YELLOW
elif [ $COMPARETEMP -le 60 ]; then
	CTEMP=$RED
fi
LOAD=`cat /proc/loadavg`
RT=`free -m | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f2`
RU=`free -m | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f3`
if [ $RU -le 500 ]; then
	CRU=$GREEN
elif [ $RU -le 750 ]; then
	CRU=$YELLOW
elif [ $RU -le 1000 ]; then
	CRU=$RED
fi
SU=`free -m | sed -n 3p | awk '{$2=$2};1' | cut -d " " -f3`
if [ $SU -le 50 ]; then
	CSU=$GREEN
elif [ $SU -le 75 ]; then
	CSU=$YELLOW
elif [ $SU -le 99 ]; then
	CSU=$RED
fi
DISK=`df -h | sed -n 2p | awk '{$2=$2};1' | cut -d " " -f5 | cut -d "%" -f1`
if [ $DISK -le 75 ]; then
	CDISK=$GREEN
elif [ $DISK -le 85 ]; then
	CDISK=$YELLOW
elif [ $DISK -le 100 ]; then
	CDISK=$RED
fi
LOGIN=`who -q | sed -n 2p |cut -c "9-11"`
PSU=`ps h U $(whoami) | wc -l`
PSA=`ps -A h | wc -l`
for i in {232..256} {256..232} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e "\e[38;5;256mS\e[38;5;254my\e[38;5;252ms\e[38;5;250mt\e[38;5;248me\e[38;5;246mm\e[38;5;244m.\e[38;5;242m.\e[38;5;240m.\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m:\e[39m" $SYSTEM
echo -e "\e[38;5;256mL\e[38;5;254ma\e[38;5;252ms\e[38;5;250mt\e[38;5;248m L\e[38;5;246mo\e[38;5;244mg\e[38;5;242mi\e[38;5;240mn\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;23.:\e[39m" $LASTLOG
echo -e "\e[38;5;256mU\e[38;5;254mp\e[38;5;252mt\e[38;5;250mi\e[38;5;248mm\e[38;5;246me\e[38;5;244m.\e[38;5;242m.\e[38;5;240m.\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m.\e[38;5;232m:\e[39m" $UPTIME
echo -e "\e[38;5;256mT\e[38;5;254me\e[38;5;252mm\e[38;5;250mp\e[38;5;248me\e[38;5;246mr\e[38;5;244ma\e[38;5;242mt\e[38;5;240mu\e[38;5;238mr\e[38;5;236me\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m.\e[38;5;232m:\e[39m" $CTEMP$TEMP"\e[39m"ºC
echo -e "\e[38;5;256mL\e[38;5;254mo\e[38;5;252ma\e[38;5;250md\e[38;5;248m.\e[38;5;246m.\e[38;5;244m.\e[38;5;242m.\e[38;5;240m.\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m.\e[38;5;232m:\e[39m" $LOAD
echo -e "\e[38;5;256mM\e[38;5;254me\e[38;5;252mm\e[38;5;250mo\e[38;5;248mr\e[38;5;246my \e[38;5;244mM\e[38;5;242mB\e[38;5;240m.\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m:\e[39m" RAM: $CRU$RU"\e[39m"/$RT SWAP: $CSU$SU"\e[39m"/99
echo -e "\e[38;5;256mD\e[38;5;254mi\e[38;5;252ms\e[38;5;250mk \e[38;5;248mU\e[38;5;246ms\e[38;5;244ma\e[38;5;242mg\e[38;5;240me\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m:\e[39m" $CDISK$DISK"\e[39m"%
echo -e "\e[38;5;256mS\e[38;5;254mS\e[38;5;252mH \e[38;5;250mL\e[38;5;248mo\e[38;5;246mg\e[38;5;244mi\e[38;5;242mn\e[38;5;240ms\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m:\e[39m" $LOGIN
echo -e "\e[38;5;256mP\e[38;5;254mr\e[38;5;252mo\e[38;5;250mc\e[38;5;248me\e[38;5;246ms\e[38;5;244ms\e[38;5;242me\e[38;5;240ms\e[38;5;238m.\e[38;5;236m.\e[38;5;234m.\e[38;5;232m.\e[38;5;232.\e[38;5;232m.\e[38;5;232m:\e[39m" $PSU User / $PSA Total
for i in {232..256} {256..232} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
