#!/vendor/bin/sh

if [ -e /mnt/vendor/persist/aw_efuse.bin ] ; then
cali=`cat /mnt/vendor/persist/aw_efuse.bin`
#cali=`cat /mnt/vendor/persist/aw_efuse.bin`| awk '{print $3, $7}'
cali1=$(echo $cali | awk '{print $3 $7}')
cali2=$(echo $cali1 |  tr ',' ' ')


echo $cali2 > /sys/class/leds/aw_vibrator/efuse
echo "[haptic] vib_load_efuse.sh: aw_efuse.bin: cali= $cali" > /dev/kmsg
#cecho "[haptic] vib_load_efuse.sh: aw_efuse.bin: cali1= $cali1" > /dev/kmsg
echo "[haptic] vib_load_efuse.sh: aw_efuse.bin: cali2= $cali2" > /dev/kmsg
else
echo "[haptic] aw_efuse.bin is not exist" > /dev/kmsg
fi
