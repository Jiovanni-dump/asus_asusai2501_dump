#!/vendor/bin/sh

stop rpm_monitor

trigger_type=`getprop vendor.fandg8.pd_fwupdate`
fw_ver=`cat /sys/class/leds/aura_inbox/pd_fw_date`
pcbid=`getprop vendor.fandg8.pcbid`

# Get target version
if [ "$pcbid" == "0x1" ]; then
	pd_asusfw_ver=`getprop vendor.asusfw.fandg8_dp.pd_fwver`
else
	pd_asusfw_ver=`getprop vendor.asusfw.fandg8.pd_fwver`
fi

# Wakeup MA51 & PD
echo 0 > /sys/class/leds/aura_inbox/gpio11

echo "[PD_INBOX] update PD from $fw_ver to $pd_asusfw_ver" > /dev/kmsg
echo 1 > /sys/class/leds/aura_inbox/pd_ISP
sleep 1
echo "[PD_INBOX] ready to update PD firmware" > /dev/kmsg
update_result=`cat /sys/class/leds/aura_inbox/pd_update`

if [ "$update_result" == "0" ]; then
	sleep 1
	fw_ver=`cat /sys/class/leds/aura_inbox/pd_fw_date`
	if [ "$fw_ver" == "$pd_asusfw_ver" ]; then
		echo "[PD_INBOX] Update PD firmware complete! Version is $fw_ver" > /dev/kmsg
		setprop vendor.inbox8.pd_fwver $fw_ver
		setprop vendor.fandg8.pd_fwupdate 0
	else
		echo "[PD_INBOX] Update PD firmware complete! But Version is wrong, $fw_ver" > /dev/kmsg
		setprop vendor.fandg8.pd_fwupdate 2
	fi
else
	echo "[PD_INBOX] Update PD firmware failed!" > /dev/kmsg
	setprop vendor.fandg8.pd_fwupdate 2
fi

start rpm_monitor
exit
