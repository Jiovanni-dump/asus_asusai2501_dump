#!/vendor/bin/sh
GRIP_FW_INFO_PATH="/sys/class/grip_sensor/aw8680x/product_config"
GRIP_CHECK_K_VERSION="117"
COUNT=0

Check_Cal_Version(){
		GRIP_K_VER_STR=`cat $GRIP_FW_INFO_PATH | grep "FW Version"`
		if ["$GRIP_K_VER_STR" == ""]; then
			GRIP_K_VER_STR=`cat "/proc/driver/grip_fw_ver"`
		fi
		echo $GRIP_K_VER_STR
		GRIP_K_VER_STR=`echo $GRIP_K_VER_STR | cut -d '.' -f4`
		setprop vendor.grip.cur.version $GRIP_K_VER_STR
		echo $GRIP_K_VER_STR
}

Check_Cal_Version

#fail count file add 1 when fw version none
GRIP_FAIL_COUNT_CHECK_STR="XXX"$GRIP_K_VER_STR"XXX"
echo "$GRIP_FAIL_COUNT_CHECK_STR"

if [ "$GRIP_FAIL_COUNT_CHECK_STR" == "XXXXXX" ]; then
	setprop vendor.grip.fw.fail.count 1
	echo "trigger fw fail count service"
fi

if [ "$GRIP_FAIL_COUNT_CHECK_STR" == "XXX00XXX" ]; then
	setprop vendor.grip.fw.fail.count 1
	echo "trigger fw fail count service"
fi

if [ "$GRIP_FAIL_COUNT_CHECK_STR" == "XXX01XXX" ]; then
	setprop vendor.grip.fw.fail.count 1
	echo "FW Version: 71.01.24.01 , No Firmware, trigger fw fail count service"
fi

GRIP_FW_EXPECT_VER=`getprop vendor.grip.cur.version`
echo "$GRIP_CHECK_K_VERSION, $GRIP_FW_EXPECT_VER"
if [ "$GRIP_CHECK_K_VERSION" == "$GRIP_FW_EXPECT_VER" ]; then
    setprop vendor.grip.chip_reset "skip_due_to_find_expect_fw_info"
else
	#reset chip when boot complete to avoid overlap file system 
	#echo 1 > /sys/class/grip_sensor/aw8680x/reset
	echo "ERROR    wrong grip fw version"
	setprop vendor.grip.chip_reset start
	sleep 10
	setprop vendor.grip.chip_reset done
fi

##### Check FW Result #####
FW_Check="`cat /proc/driver/grip_fw_result`"
setprop vendor.grip.fw.result $FW_Check
