#!/vendor/bin/sh

option=`getprop debug.asus.csc.miniledtest`

case ${option} in
	"0")
		echo 0 > /sys/class/leds/miniled/test
	;;
	"1")
		echo 1 > /sys/class/leds/miniled/test
	;;
	"2")
		echo 2 > /sys/class/leds/miniled/test
	;;
	"3")
		echo 3 > /sys/class/leds/miniled/test
	;;
	"10")
		echo "full brightness"
		echo 255 > /sys/class/leds/miniled/tmp_pattern
		echo 255 > /sys/class/leds/miniled/test

		result=`cat /sys/class/leds/miniled/tmp_pattern`
		if [ "$result" == "0xff, 0xff" ]; then
				echo PASS
				setprop vendor.asus.atd.miniledtest 1
		else
				echo FAIL
				setprop vendor.asus.atd.miniledtest 0
		fi

	;;
	"11")
		echo "half brightness"
		echo 63 > /sys/class/leds/miniled/tmp_pattern
		echo 255 > /sys/class/leds/miniled/test

		result=`cat /sys/class/leds/miniled/tmp_pattern`
		if [ "$result" == "0x3f, 0x3f" ]; then
				echo PASS
				setprop vendor.asus.atd.miniledtest 1
		else
				echo FAIL
				setprop vendor.asus.atd.miniledtest 0
		fi
	;;
  *)
		echo "Usage error parameter."
	;;
esac

exit
