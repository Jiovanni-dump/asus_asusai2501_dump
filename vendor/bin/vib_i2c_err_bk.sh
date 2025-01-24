#!/vendor/bin/sh

#define AW269xx_I2C_ERROR_PATH "/sys/class/leds/aw_vibrator/i2c_error"
#define AW269xx_I2C_ERROR_PROP "persist.vendor.fail_cnt.vib"

result1=`getprop persist.vendor.fail_cnt.vib`
echo "[haptic] vib_i2c_err_bk.sh org persist.vendor.fail_cnt.vib = $result1" > /dev/kmsg

result2=`cat /sys/class/leds/aw_vibrator/i2c_error`
echo "[haptic] vib_i2c_err_bk.sh /sys/class/leds/aw_vibrator/i2c_error= $result2" > /dev/kmsg

if [ -z "$result1" ]; then
    result1=0
fi

if [ -z "$result2" ]; then
    result2=0
fi

result=`expr $result1 + $result2`
echo "[haptic] vib_i2c_err_bk.sh new persist.vendor.fail_cnt.vib = $result" > /dev/kmsg
setprop persist.vendor.fail_cnt.vib "$result"

