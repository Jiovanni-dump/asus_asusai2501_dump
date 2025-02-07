#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
latch_status=`cat /sys/class/leds/aura_inbox/latch_status`

if [ "$type" != "10" ] || [ "$latch_status" != "1" ]; then
	echo "[AURA_INBOX] Inbox 8 diconnect ($type  $latch_status)  , terminate the update process!" > /dev/kmsg
	setprop vendor.fandg8.2led_fwupdate 2
	exit
fi

stop rpm_monitor

pcbid=`getprop vendor.fandg8.pcbid`

# Get target version
if [ "$pcbid" == "0x1" ]; then
	aura_2led_target_ver=`getprop vendor.asusfw.fandg8_dp.2led_fwver`
else
	aura_2led_target_ver=`getprop vendor.asusfw.fandg8.2led_fwver`
fi

# Which aura should update
aura_2led_update=`getprop vendor.fandg8.2led_fwupdate`


if [ "$aura_2led_update" == "1" ]; then
	echo "[AURA_INBOX] Prepare to update 2led to $aura_2led_target_ver" > /dev/kmsg
	aura_id=1
fi

if [ "$aura_id" == "1" ]; then
	echo "[AURA_INBOX] Start update 2led" > /dev/kmsg
fi

# Wakeup MA51 & PD
echo 0 > /sys/class/leds/aura_inbox/gpio11

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
		setprop vendor.inbox8.2led_fwver $current_ver
		setprop vendor.fandg8.2led_fwupdate 0
		exit 0
	else
		echo "[AURA_INBOX] Update 2led failed" > /dev/kmsg
		setprop vendor.fandg8.2led_fwupdate 2
		exit 0
	fi
fi
