#!/vendor/bin/sh

result=`cat /sys/class/asuslib/asus_get_bat_serial_number`

setprop persist.vendor.asus.battery_serial_number "$result"

echo -n $result > /batinfo/FAC_bat_serial_number

echo "[BAT][CHG] bat_serial_number_basckup.sh: persist.vendor.asus.battery_serial_number  = $result" > /dev/kmsg
