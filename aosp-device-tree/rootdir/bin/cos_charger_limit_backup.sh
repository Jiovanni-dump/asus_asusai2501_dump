#!/vendor/bin/sh

result1=`getprop vendor.charger.limit`

echo -n $result1 > /batinfo/cos_charger_limit

echo "[BAT][CHG][bq28z610] cos_charger_limit_backup.sh: /batinfo/cos_charger_limit = $result1" > /dev/kmsg
