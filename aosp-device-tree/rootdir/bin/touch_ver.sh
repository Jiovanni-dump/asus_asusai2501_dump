#!/vendor/bin/sh
path="/sys/bus/platform/devices/synaptics_tcm.0/sysfs"

fw_err=234
sleep 1.5
TP1_VER_PACK=`cat ${path}/fw_ver`
echo "[SYNA]FW version $TP1_VER_PACK" > /dev/kmsg
if [ "$($TP1_VER_PACK)" == "${fw_err}" ]; then
sleep 7
TP1_VER_PACK=`cat ${path}/fw_ver`
echo "[SYNA]get FW version $TP1_VER_PACK" > /dev/kmsg
setprop vendor.touch.version.driver "$TP1_VER_PACK"
else
setprop vendor.touch.version.driver "$TP1_VER_PACK"
fi
