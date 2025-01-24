#!/vendor/bin/sh
if [ -e /batinfo/cos_charger_limit ] ; then
scale=`cat /batinfo/cos_charger_limit`
echo $scale > /sys/devices/platform/charger/cos_charger_limit
echo $scale > /sys/class/asuslib/cos_charger_limit
echo "[BAT][CHG][bq28z610] cos_charger_limit_restore.sh: /batinfo/cos_charger_limit: $scale" > /dev/kmsg
else
echo "[BAT][CHG][bq28z610] cos_charger_limit_restore.sh: /batinfo/cos_charger_limit is not exist" > /dev/kmsg
fi
