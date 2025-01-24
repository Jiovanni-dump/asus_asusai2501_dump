#!/vendor/bin/sh

result1=`getprop vendor.battery.serial_number.date`

echo -n $result1 > /sys/class/asuslib/asus_get_bat_serial_number_date

echo "[BAT][CHG] bat_serial_number_backup2.sh: vendor.battery.serial_number.date = $result1" > /dev/kmsg

echo -n $result1 > /batinfo/bat_serial_number_date

echo "[BAT][CHG] bat_serial_number_backup2.sh: /batinfo/bat_serial_number_date = $result1" > /dev/kmsg

result2=`cat /sys/class/asuslib/asus_get_bat_serial_number`

echo -n $result2 > /batinfo/bat_serial_number

echo "[BAT][CHG] bat_serial_number_backup2.sh: /batinfo/bat_serial_number = $result2" > /dev/kmsg


