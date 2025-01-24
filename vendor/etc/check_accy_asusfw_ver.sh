#!/vendor/bin/sh

#prop_type=`getprop vendor.asus.dongletype`

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN8_2LED_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg8.2led_fwver $FW_VER

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN8_PD_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg8.pd_fwver $FW_VER

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN8_2LED_DP_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg8_dp.2led_fwver $FW_VER

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN8_PD_DP_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg8_dp.pd_fwver $FW_VER

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN9_2LED_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg9.2led_fwver $FW_VER

FW_VER=`cat /vendor/firmware/FW_version.txt | grep FAN9_PD_FW | cut -d ':' -f 2`
setprop vendor.asusfw.fandg9.pd_fwver $FW_VER

echo "[ACCY] Check Accy AsusFW Ver Done" > /dev/kmsg
