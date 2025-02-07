#!/vendor/bin/sh

sleep 5

if [ -e /batinfo/bat_serial_number ] ; then

result1=`cat /batinfo/bat_serial_number`

echo -n $result1 > /sys/class/asuslib/asus_get_bat_serial_number2

echo "[BAT][CHG] bat_serial_number_restore2.sh: /batinfo/bat_serial_number: $result1" > /dev/kmsg

result2=`cat /batinfo/bat_serial_number_date`

echo -n $result2 > /sys/class/asuslib/asus_get_bat_serial_number_date

echo "[BAT][CHG] bat_serial_number_restore2.sh: /batinfo/bat_serial_number_date: $result2" > /dev/kmsg

else

echo "[BAT][CHG] bat_serial_number_restore2.sh: /batinfo/bat_serial_number is not exist" > /dev/kmsg

fi
