#!/vendor/bin/sh

echo $0 > /dev/kmsg

# mount logfs & copy UefiLog/xbl_sc_logs
mkdir /data/logcat_log/logfs
chmod 777 /data/logcat_log/logfs
cp /dev/block/by-name/xbl_sc_logs /asdf/logfs

cat /asdf/logfs/xbl_sc_logs | grep "OCP" > /asdf/OCP.log

OCP_count=`cat /asdf/OCP.log | grep -c Reset`
setprop persist.vendor.asus.ocp_count $OCP_count

size=`stat -c%s /asdf/OCP.log`
if [ $size -gt 1048576 ]; then
	    truncate -s 1048576 /asdf/OCP.log
fi

