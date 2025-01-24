#!/system/bin/sh

#echo $0 > /dev/kmsg

#echo "=====" > asdf/top.log

get_pid=$(cat /proc/asusperftop_getpid)

#echo "[perftop.sh]:get_pid= $get_pid" > /dev/kmsg

pid=$(cat /proc/asusperftop_pid)

#echo "[perftop.sh]:asusperftop_pid:pid= $pid" > /dev/kmsg

if [ "$get_pid" -eq "1" ] || [ "$pid" -eq 0 ] || [ "$pid" = "" ]; then
	package_name=$(cat /proc/asusperftopapp)
#	output=$(ps -A | awk -v pkg="$package_name" '$NF == pkg')
#	pid=$(echo "$output" | awk 'NR==1{print $2}')

#	package_name_top=$(top -m 10 -n 1 -q -b | grep $package_name | awk 'NR==1 {print $NF}')
	pid=$(top -m 10 -n 1 -q -b | grep $package_name | awk 'NR==1 {print $1}')

#	echo "[perftop.sh]:package_name= $package_name" > /dev/kmsg
#	echo "[perftop.sh]:output= $output" > /dev/kmsg
#	echo "[perftop.sh]:package_name_top= $package_name_top" > /dev/kmsg
#	echo "[perftop.sh]:ps:pid= $pid" > /dev/kmsg

	echo "$pid" > /proc/asusperftop_pid
	echo "0" > /proc/asusperftop_getpid
fi

if [ "$pid" -gt 0 ]; then
    top -p $pid -H -m 5 -n 1 -q -b > /proc/asusperftop

#	echo "[perftop.sh]:top -p $pid -H -m 5 -n 1 -q -b" > /dev/kmsg
else
    top -H -m 10 -n 1 -q -b > /proc/asusperftop

#	echo "[perftop.sh]:top -H -m 10 -n 1 -q -b" > /dev/kmsg
fi

#sleep 5

#echo "\n" >> asdf/top.log
#echo "done" >> asdf/top.log

#echo "perftop.sh EXIT" > /dev/kmsg
