#!/vendor/bin/sh
GRIP_I2C_FAIL_COUNT_PROP=`getprop vendor.grip.i2c.fail.count`
GRIP_READ_I2C_FAIL_COUNT=`getprop persist.vendor.fail_cnt.grip_i2c`
if [ "$GRIP_READ_I2C_FAIL_COUNT" == "" ]; then
    GRIP_READ_I2C_FAIL_COUNT=0
fi

if [ "$GRIP_I2C_FAIL_COUNT_PROP" == "1" ]; then
    GRIP_READ_I2C_FAIL_COUNT=`expr $GRIP_READ_I2C_FAIL_COUNT + 1`
    setprop vendor.grip.i2c.fail.count 0
    setprop vendor.grip.i2c.fail.count_read $GRIP_READ_I2C_FAIL_COUNT
fi
