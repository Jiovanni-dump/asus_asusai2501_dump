#!/vendor/bin/sh

result1=`getprop persist.vendor.asus.battery_serial_number`
echo "[BAT][CHG] bat_serial_number_restore.sh: persist.vendor.asus.battery_serial_number     = $result1" > /dev/kmsg

result2=`cat /batinfo/FAC_bat_serial_number`
echo "[BAT][CHG] bat_serial_number_restore.sh: /batinfo/FAC_bat_serial_number                = $result2" > /dev/kmsg

result3=`cat /sys/class/asuslib/asus_get_bat_serial_number`
echo "[BAT][CHG] bat_serial_number_restore.sh: /sys/class/asuslib/asus_get_bat_serial_number = $result3" > /dev/kmsg

if [ "$result1" != "" ] ; then

    if [ "$result2" == "" ] ; then
        echo -n $result1 > /batinfo/FAC_bat_serial_number
        echo "[BAT][CHG] bat_serial_number_restore.sh: backup to /batinfo/FAC_bat_serial_number = $result1" > /dev/kmsg
    fi
    echo -n $result1 > /sys/class/asuslib/asus_get_bat_serial_number
    echo "[BAT][CHG] bat_serial_number_restore.sh: persist.vendor.asus.battery_serial_number = $result1" > /dev/kmsg

elif [ "$result2" != "" ] ; then

    echo -n $result2 > /sys/class/asuslib/asus_get_bat_serial_number
    echo "[BAT][CHG] bat_serial_number_restore.sh: /batinfo/FAC_bat_serial_number = $result2" > /dev/kmsg

elif [ "$result3" != "" ] ; then

    echo -n $result3 > /batinfo/FAC_bat_serial_number
    echo "[BAT][CHG] bat_serial_number_restore.sh: no any FAC bat serial number, force set = $result3" > /dev/kmsg

else

    echo "[BAT][CHG] bat_serial_number_restore.sh: can not read battery_serial_number!" > /dev/kmsg

fi
