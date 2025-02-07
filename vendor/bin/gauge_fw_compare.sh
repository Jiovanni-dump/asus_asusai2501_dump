#!/vendor/bin/sh

FW_compare=`cat /sys/class/asuslib/asus_get_gauge_FW_compare`
setprop vendor.battery.version.gauge_FW_compare "$FW_compare"

