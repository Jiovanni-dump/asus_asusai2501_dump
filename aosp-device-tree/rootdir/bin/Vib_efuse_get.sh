#!/vendor/bin/sh

#rm -rf /mnt/vendor/persist/aw_cali.bin
#rm -rf /mnt/vendor/persist/aw_rtp_cali.bin

if [ -e /mnt/vendor/persist/aw_efuse.bin ] ; then
echo "[haptic] Vib_efuse_get.sh: /mnt/vendor/persist/aw_efuse.bin exist" > /dev/kmsg

else
echo "[haptic] aw_efuse.bin is not exist, execute Vib_efuse_get.sh backup" > /dev/kmsg
efuse_r=`cat /sys/class/leds/aw_vibrator/efuse`
sleep 1

#echo 1:$efuse_r
r=`echo $efuse_r |grep -e ff -e fail`
#echo 2:$r
len=`expr ${#r}`
#echo len:$len

if [ $len -ne 0 ] ; then
  echo $efuse_r
  echo "[haptic] Vib_efuse_get.sh: aw_efuse.bin fail: $efuse_r" > /dev/kmsg
  exit
fi

echo -n $efuse_r > /mnt/vendor/persist/aw_efuse.bin
echo "[haptic] Vib_efuse_get.sh: aw_efuse.bin success: $efuse_r" > /dev/kmsg

fi

