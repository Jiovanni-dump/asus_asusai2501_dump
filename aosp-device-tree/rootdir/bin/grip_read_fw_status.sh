#!/vendor/bin/sh
GRIP_FW_FAIL_COUNT_FILE="/vendor/factory/grip_fw_fail_count.txt"
GRIP_FW_FAIL_COUNT_PROP=`getprop vendor.grip.fw.fail.count`

GRIP_READ_PERSIST_FW_FAIL_COUNT=`getprop persist.vendor.fail_cnt.grip`
if [ "$GRIP_READ_PERSIST_FW_FAIL_COUNT" == "" ]; then
    GRIP_READ_PERSIST_FW_FAIL_COUNT=0
fi


if [ "$GRIP_FW_FAIL_COUNT_PROP" == "1" ]; then
    GRIP_READ_FW_FAIL_COUNT=`cat $GRIP_FW_FAIL_COUNT_FILE`
    GRIP_READ_FW_FAIL_COUNT=`expr $GRIP_READ_FW_FAIL_COUNT + 1`
    echo $GRIP_READ_FW_FAIL_COUNT > $GRIP_FW_FAIL_COUNT_FILE

    GRIP_READ_PERSIST_FW_FAIL_COUNT=`expr $GRIP_READ_PERSIST_FW_FAIL_COUNT + 1`

    setprop vendor.grip.fw.fail.count 0
    setprop vendor.grip.fw.fail.count_read $GRIP_READ_FW_FAIL_COUNT
    setprop vendor.grip.fw.fail.count_read_user $GRIP_READ_PERSIST_FW_FAIL_COUNT
fi
