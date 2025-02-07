#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`

echo "[ROG_ACCY] DongleRemove, type $type" > /dev/kmsg
echo "[ROG_ACCY] Stop rogaccyswitch" > /dev/kmsg
stop rogaccyswitch

echo "[ROG_ACCY] Stop rpm_monitor" > /dev/kmsg
stop rpm_monitor

# do not add any action behind here
setprop vendor.asus.donglechmod 0
setprop vendor.asus.fan_pjid 0

# reset fandongle 8 firmware version
setprop vendor.inbox8.2led_fwver 0
setprop vendor.inbox8.pd_fwver 0

# reset fandongle 9 firmware version
setprop vendor.inbox9.2led_fwver 0
setprop vendor.inbox9.pd_fwver 0

# force reset accy FW
setprop vendor.inbox.aura_fwver 0
setprop vendor.inbox.inbox_fwver 0
setprop vendor.inbox.pd_fwver 0
setprop vendor.asus.accy.fw_status 000000
setprop vendor.asus.accy.fw_status2 000000
#setprop vendor.oem.asus.inboxid 0

# CSC reset
setprop persist.vendor.asus.coolerstage_csc -1
