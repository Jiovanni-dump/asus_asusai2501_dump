#!/vendor/bin/sh

adsp_ramdump=`getprop persist.vendor.asus.adsp.ramdump`
adsp_remoteproc=`ls -d /sys/devices/platform/soc/3000000.remoteproc-adsp/remoteproc/*/recovery`

if [ -f $adsp_remoteproc ]; then
	if [ "${adsp_ramdump}" = "1" ]; then
		echo "disabled" > $adsp_remoteproc
		echo "$0: disabled $adsp_remoteproc"
	fi
	if [ "${adsp_ramdump}" = "0" ]; then
		echo "enabled" > $adsp_remoteproc
		echo "$0: enabled $adsp_remoteproc"
	fi
fi
