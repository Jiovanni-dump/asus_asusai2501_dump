#!/vendor/bin/sh

setprop vendor.phone.miniled.update_process 1

hwid=`getprop ro.boot.id.stage`
pjid=`getprop ro.boot.id.prj`

#if [ "${pjid}" != "1" ]; then
#	echo "[MINILED_MM32_UPDATE] Device is not ultimate , stop fw update" > /dev/kmsg
#	exit 0;
#fi
#	if [ "${hwid}" == "0" || "${hwid}" == "1"]; then
#	echo "[MINILED_MM32_UPDATE] Device is EVB or SR1 , stop fw update" > /dev/kmsg
#	exit 0;
#fi

FW_Entry=`cat /vendor/firmware/FW_version.txt | grep Miniled_Entry_FW | cut -d ':' -f 2`
setprop vendor.asusfw.phone.miniled_entry_fwver $FW_Entry

FW_Pro=`cat /vendor/firmware/FW_version.txt | grep Miniled_Pro_FW | cut -d ':' -f 2`
setprop vendor.asusfw.phone.miniled_pro_fwver $FW_Pro

vdd_tmp=`cat /sys/class/leds/miniled/VDD`

if [ "${vdd_tmp}" != "1" ]; then
	echo "[MINILED_MM32_UPDATE] Enable VDD" > /dev/kmsg
	echo 1 > /sys/class/leds/miniled/VDD
	sleep 0.5
fi

lgfid=`cat /sys/class/leds/miniled/PD6`
current_ver=`cat /sys/class/leds/miniled/FW_Ver`

if [ "${lgfid}" == "0x1" ]; then
	latest_ver=`getprop vendor.asusfw.phone.miniled_entry_fwver`
else
	latest_ver=`getprop vendor.asusfw.phone.miniled_pro_fwver`
fi

echo "[MINILED_MM32_UPDATE] hwid : ${hwid}" > /dev/kmsg
echo "[MINILED_MM32_UPDATE] pjid : ${pjid}" > /dev/kmsg

echo "[MINILED_MM32_UPDATE] Latest_ver : ${latest_ver}" > /dev/kmsg
echo "[MINILED_MM32_UPDATE] Current_ver : ${current_ver}" > /dev/kmsg

if [ "${current_ver}" == "${latest_ver}" ]; then
	echo "[MINILED_MM32_UPDATE] No need update" > /dev/kmsg
	setprop vendor.phone.miniled_fwver $current_ver
	setprop vendor.phone.miniled_fwupdate 0
	setprop vendor.phone.miniled.update_process 0

	echo $vdd_tmp > /sys/class/leds/miniled/VDD
	exit 0;
fi

function Update() {
	echo 1 > /sys/class/leds/miniled/FW_Update
	sleep 0.5
}

retry=0

while [ "$retry" -le 5 ]  # the most retry times is 5
do
	Update;

	current_ver=`cat /sys/class/leds/miniled/FW_Ver`

	if [ "${current_ver}" == "${latest_ver}" ]; then
		echo "[MINILED_MM32_UPDATE] Update Successfully." > /dev/kmsg
		setprop vendor.phone.miniled_fwver $current_ver
		setprop vendor.phone.miniled_fwupdate 0
		setprop vendor.phone.miniled.update_process 0

		echo $vdd_tmp > /sys/class/leds/miniled/VDD
		exit 0;
	fi

	echo "[MINILED_MM32_UPDATE] Current_ver : ${current_ver} != Latest_ver : ${latest_ver}" > /dev/kmsg
	echo "[MINILED_MM32_UPDATE] Re-try $retry" > /dev/kmsg

	#Todo: reset
	echo 0 > /sys/class/leds/miniled/VDD
	sleep 0.2
	echo 1 > /sys/class/leds/miniled/VDD
	sleep 0.5

	retry=$((retry + 1 ))
done

echo "[MINILED_MM32_UPDATE] Update Fail." > /dev/kmsg
setprop vendor.phone.miniled_fwupdate 2
setprop vendor.phone.miniled.update_process 0
