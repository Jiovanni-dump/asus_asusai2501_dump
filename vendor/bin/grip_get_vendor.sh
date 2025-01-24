#!/vendor/bin/sh
if [ -d "/sys/class/grip_sensor/snt8100fsr" ]; then
	echo snt
else
	echo ndt
fi
