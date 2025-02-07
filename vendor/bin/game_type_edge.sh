#!/vendor/bin/sh
#path="/sys/bus/platform/devices/synaptics_tcm.0/sysfs"
#echo "[SYNA] enter game_type_edge+++++++" > /dev/kmsg

# ro.boot.id.prj // return 2 is HAVANA
# vendor.asus.gamingtype // 1: in game list but 0 is not
PROJECT_ID=`getprop ro.boot.id.prj`
GAMING_TYPE=`getprop vendor.asus.gamingtype`

#echo "[SYNA] enter script++++" > /dev/kmsg
if [ "$PROJECT_ID" == "2" ]; then
	if [ "$GAMING_TYPE" == "1" ]; then
		echo "[SYNA] enter game mode GAMING_TYPE=  $GAMING_TYPE" > /dev/kmsg
		setprop vendor.asus.touch.edge_settings "008.008"
		echo "[SYNA] setprop vendor.asus.touch.edge_settings 008.008" > /dev/kmsg
		setprop vendor.asus.touch.report_rate "360"
		echo "[SYNA] setprop vendor.asus.touch.report_rate 360" > /dev/kmsg
	else
		echo "[SYNA] exit game mode GAMING_TYPE=  $GAMING_TYPE" > /dev/kmsg
		setprop vendor.asus.touch.edge_settings "011.011"
		echo "[SYNA] setprop vendor.asus.touch.edge_settings 011.011" > /dev/kmsg
		setprop vendor.asus.touch.report_rate "120"
		echo "[SYNA] setprop vendor.asus.touch.report_rate 120" > /dev/kmsg
	fi
fi
#echo "[SYNA] exit game_type_edge----" > /dev/kmsg
