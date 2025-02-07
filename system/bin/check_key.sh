#!/system/bin/sh
PATH=/system/bin/:$PATH

export_check_persist() {
	setprop vendor.asus.persist_data_list.status 1
	sleep 5
	ls_persist=`cat /asdf/persist_data_directory.txt`
	setprop vendor.asus.persist_data_list.directory  $ls_persist
	setprop vendor.asus.persist_data_list.status 0
}
export_check_key() {
	#am start -S -n com.asus.atd.deviceproperty/.MainActivity -e getinfo "AttesetationKey"
	am start-foreground-service -n com.asus.key_status/.A_KEY
	#am startservice -n com.asus.key_status/.A_KEY
	sleep 20

	akey_status=`getprop sys.asus.attk.status`
	echo "[AKEY]: check ${akey_status}" > /proc/asusevtlog

	if [ "${akey_status}" = "FALSE" ]; then
		echo "[rkp_reinstall][setprop vendor.asus.system.get.deviceid.status=1]: resintall rkp" > /proc/asusevtlog
		setprop vendor.asus.system.get.deviceid.status 1
	fi
	am force-stop com.asus.key_status
	echo "[AKEY]: check done!" > /proc/asusevtlog
}

export_check_widevine() {
	Wv=`getprop sys.drm.systemid`
	if [ "$Wv" == "2147483647" ]; then
       		setprop vendor.drm.keyready FALSE
       		break
	else
       		setprop vendor.drm.keyready TRUE
       		break
	fi
}

trigger_status=`getprop vendor.asus.check_trigger`
after_status=`getprop vendor.asus.after_check.status`
echo "[AKEY]: check trigger_status=${trigger_status} after_status=${after_status}" > /proc/asusevtlog
if [ "${after_status}" == "0"  -a  "${trigger_status}" == "1" ]; then
	export_check_persist
	export_check_key
	setprop vendor.asus.after_check.status 1
	return 0
fi


export_check_persist
echo "[AKEY]: boot complete" > /proc/asusevtlog
sleep 5m
echo "[AKEY]: start" > /proc/asusevtlog

count="1"
while [ 1 ]
do
echo $count
count=$(($count+1))
setprop vendor.asus.after_check.status 0
export_check_persist
export_check_key
export_check_widevine
sleep 12h
done
