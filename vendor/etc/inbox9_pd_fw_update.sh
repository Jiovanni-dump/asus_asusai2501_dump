#!/vendor/bin/sh

stop rpm_monitor

retry=5
fw_ver=`cat /sys/class/leds/aura_inbox/pd_fw_date`
pjid=`getprop vendor.asus.fan_pjid`

echo "[PD_INBOX] FAN9 project ID = $pjid" > /dev/kmsg

# Get target version
pd_asusfw_ver=`getprop vendor.asusfw.fandg9.pd_fwver`

# Wakeup MA51 & PD
echo 1 > /sys/class/leds/aura_inbox/HDC2010_HS_INT

echo "[PD_INBOX] update PD from $fw_ver to $pd_asusfw_ver" > /dev/kmsg
echo 1 > /sys/class/leds/aura_inbox/pd_ISP
sleep 1
echo "[PD_INBOX] ready to update PD firmware" > /dev/kmsg
update_result=`cat /sys/class/leds/aura_inbox/pd_update`

if [ "$update_result" == "0" ]; then
	sleep 1
	fw_ver=`cat /sys/class/leds/aura_inbox/pd_fw_date`
	while [ "$retry" -gt 0 ] && [ "$fw_ver" != "$pd_asusfw_ver" ]
	do
		fw_ver=`cat /sys/class/leds/aura_inbox/pd_fw_date`
		((retry--))
		sleep 1
	done

	if [ "$fw_ver" == "$pd_asusfw_ver" ]; then
		echo "[PD_INBOX] Update PD firmware complete! Version is $fw_ver" > /dev/kmsg
		setprop vendor.inbox9.pd_fwver $fw_ver
		setprop vendor.fandg9.pd_fwupdate 0
	else
		echo "[PD_INBOX] Update PD firmware complete! But Version is wrong, $fw_ver" > /dev/kmsg
		setprop vendor.fandg9.pd_fwupdate 2
	fi
else
	echo "[PD_INBOX] Update PD firmware failed!" > /dev/kmsg
	setprop vendor.fandg9.pd_fwupdate 2
fi

start rpm_monitor
exit
