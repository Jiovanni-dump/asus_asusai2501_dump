#!/vendor/bin/sh

sleep 5

if [ -e /batinfo/bat_serial_number_date ] ; then
data=`cat /batinfo/bat_serial_number_date`
setprop vendor.battery.activate_date "$data"
echo "[BAT][CHG] battery_activate_date_restore.sh: The battery has been replaced" > /dev/kmsg
echo "[BAT][CHG] battery_activate_date_restore.sh: /batinfo/bat_serial_number_date: $data" > /dev/kmsg

elif [ -e /batinfo/battery_activate_date ] ; then
data=`cat /batinfo/battery_activate_date`
setprop vendor.battery.activate_date "$data"
echo "[BAT][CHG] battery_activate_date_restore.sh: The battery has NOT been replaced" > /dev/kmsg
echo "[BAT][CHG] battery_activate_date_restore.sh: /batinfo/battery_activate_date: $data" > /dev/kmsg

else
echo "[BAT][CHG] battery_activate_date_restore.sh: vendor.battery.activate_date is not exist" > /dev/kmsg
fi
