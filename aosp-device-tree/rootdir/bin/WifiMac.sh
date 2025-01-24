wifi_mac=`sed -n '1 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf0MacAddress=/ }
setprop ro.vendor.wifimac $wifi_mac
wifi_mac=`sed -n '2 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf1MacAddress=/ }
setprop ro.vendor.wifimac_2 $wifi_mac

setprop vendor.wifi.version.driver WLAN.GNG.1.0-03392.3-QCAGNGSWPL_V1.0_V2.0_SILICONZ-1.87705.4.88829.2

# BT
setprop vendor.bt.version.driver BTFW.BRAHMA.2.0.0-00204-PATCHZ-1
setprop ro.vendor.btmac `btnvtool -x 2>&1`
