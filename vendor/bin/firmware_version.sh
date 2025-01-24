#!/vendor/bin/sh

BATTERY=`cat /sys/class/asuslib/asus_get_fw_version`
setprop vendor.battery.version.driver "$BATTERY"

BATTERY=`cat /sys/class/asuslib/asus_get_soh`
setprop vendor.battery.health "$BATTERY"

BATTERY=`cat /sys/class/asuslib/asus_get_manufacture_date`
setprop vendor.battery.manufacture_date "$BATTERY"

BATTERY=`cat /sys/class/asuslib/asus_get_cycle_count`
setprop vendor.battery.cycle_count "$BATTERY"

BATTID=`cat /sys/class/asuslib/asus_get_BattID`
if [ "115000" -ge "$BATTID" ] && [ "$BATTID" -ge "85000" ]; then
	BATTID="cos_100K"
elif [ "11500" -ge "$BATTID" ] && [ "$BATTID" -ge "8500" ]; then
	BATTID="cos_10K"
fi
setprop vendor.battery.id.driver "$BATTID"

WLCVERSION=`cat /sys/class/asuslib/wlc_nu1628_fw_update`
setprop vendor.wlc.support.driver 1
