#!/vendor/bin/sh

inbox_id="Audio"
inbox_usbid=`cat /proc/asound/$inbox_id/usbid` > /dev/null 2>&1

if [ "$inbox_usbid" == "0b05:7a01" ]; then
    inbox_headset_state=`cat /sys/class/leds/aura_inbox/Fan9_HS_plugin` > /dev/null 2>&1
    if [ "$inbox_headset_state" == "1" ]; then
        echo "1"
    else
        echo "0"
    fi
else
    echo "0"
fi
