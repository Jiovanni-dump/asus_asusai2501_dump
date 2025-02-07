#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
latch_status=`cat /sys/class/leds/aura_inbox/latch_status`
pjid=`getprop vendor.asus.fan_pjid`

#if [ "$pjid" != "4" ] && [ "$pjid" != "5" ] || [ "$latch_status" != "1" ]; then
#	echo "[AURA_INBOX] Inbox 9 diconnect ($pjid  $latch_status)  , terminate the update process!" > /dev/kmsg
#	setprop vendor.fandg9.2led_fwupdate 2
#	exit
#fi

stop rpm_monitor

# Get target version
aura_2led_target_ver=`getprop vendor.asusfw.fandg9.2led_fwver`

# Which aura should update
aura_2led_update=`getprop vendor.fandg9.2led_fwupdate`


if [ "$aura_2led_update" == "1" ]; then
	echo "[AURA_INBOX] Prepare to update 2led to $aura_2led_target_ver" > /dev/kmsg
	aura_id=1
fi

if [ "$aura_id" == "1" ]; then
	echo "[AURA_INBOX] Start update 2led" > /dev/kmsg
fi

# Wakeup MA51 & PD
echo 1 > /sys/class/leds/aura_inbox/HDC2010_HS_INT

echo "$aura_id" > /sys/class/leds/aura_inbox/ap2ld
sleep 1
echo "$aura_id" > /sys/class/leds/aura_inbox/fw_update
sleep 1
echo "$aura_id" > /sys/class/leds/aura_inbox/ld2ap

sleep 1

echo "$aura_id" > /sys/class/leds/aura_inbox/ic_switch
current_ver=`cat /sys/class/leds/aura_inbox/fw_ver`

if [ "$aura_id" == "1" ]; then
	if [ "$current_ver" == "$aura_2led_target_ver" ]; then
		echo "[AURA_INBOX] Update 2led complete! Version = $current_ver" > /dev/kmsg
		setprop vendor.inbox9.2led_fwver $current_ver
		setprop vendor.fandg9.2led_fwupdate 0
		exit 0
	else
		echo "[AURA_INBOX] Update 2led failed" > /dev/kmsg
		setprop vendor.fandg9.2led_fwupdate 2
		exit 0
	fi
fi
