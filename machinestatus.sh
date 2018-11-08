#!/usr/bin/env bash

# Written by uger to keep track of homeserver


function get_localipaddr() {
	localipaddr="$(ip addr show wlp2s0 | grep 'inet\s' | awk '{print $2}')"
	echo $localipaddr
}

function get_publicipaddr() {
	publicipaddr="$(dig +short myip.opendns.com @resolver1.opendns.com)"
	echo $publicipaddr
}

get_memoryusage() {
	used_memory="$(free -m | tr -s ' ' | cut -d ' ' -f 3 | sed '2q;d')"
	free_memory="$(free -m | tr -s ' ' | cut -d ' ' -f 4 | sed '2q;d')"
	echo $used_memory $free_memory
}

function get_storageusage() {
	read -r storage_name storage_usage <<<$(df -h | grep sda6 | tr -s ' ' | awk '{print $1, $5}')
	echo $storage_name $storage_usage
}

function connection_check() {
	#internet_status="$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo 1 || echo 0)"
	wget -q --spider http://google.com
	if [ $? -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

sudo service network-manager restart

set -x

timestamp=`date "+%d-%m-%Y|%H:%M:%S"`
logfile=/home/karacal/Scripts/Logs/statemac.$timestamp

echo "Starting work" >> $logfile 2>&1

if connection_check
then
	lipaddr=$(get_localipaddr)
	pipaddr=$(get_publicipaddr)
	read umemory fmemory < <(get_memoryusage)
	read nstorage ustorage < <(get_storageusage)
	echo " " >> $logfile 2>&1
	echo "********** Karacal Machine **********" >> $logfile 2>&1
	echo "********** Network Status **********" >> $logfile 2>&1
	echo -e "***** Local IP: $lipaddr ****** \n***** Public IP: $pipaddr *******" >> $logfile 2>&1
	echo "-------------------------------------" >> $logfile 2>&1
	echo "***** Memory and Storage Status *****" >> $logfile 2>&1
	echo -e "***** Used Memory: $umemory ************** \n***** Free Memory: $fmemory **************" >> $logfile 2>&1
	echo -e "***** Storage: $nstorage ************ \n***** Used Storage: $ustorage *************" >> $logfile 2>&1
	echo " " >> $logfile 2>&1
	echo "Stoping work" >> $logfile 2>&1
	mail -s "Karacal Machine Status" ugur.ersoy@msn.com < $logfile
else
	echo "NO Internet Connection" >> $logfile 2>&1
	echo "Stoping work" >> $logfile 2>&1
fi

