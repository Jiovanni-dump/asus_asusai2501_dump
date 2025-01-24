#!/vendor/bin/sh

#define None                       0
#define Inbox                       1<<0
#define GamePad               1<<1
#define HeadPhone             1<<2
#define MagSafe                 1<<3
#define WirelessCharge     1<<4
#define HeadPhoneForID   1<<5

#export PATH=/vendor/bin
ACCESSORY_STATUS_PATH="/sys/class/sensors_fasync/sensors_fasync/accessory_status"
#echo $GAMEPAD_PATH
ACCESSORY_STATUS__DATA=`cat $ACCESSORY_STATUS_PATH`
#echo $GAMEPAD_DATA

COUNTRY_PROP="ro.boot.country_code"
#echo $COUNTRY_PROP
COUNTRY_VAL=`getprop $COUNTRY_PROP`
#echo $COUNTRY_VAL

setprop vendor.asus.mag.accessory $ACCESSORY_STATUS__DATA
#if [ 0 == $ACCESSORY_STATUS__DATA ]|| [ 2 == $ACCESSORY_STATUS__DATA ]|| [ 8 == $ACCESSORY_STATUS__DATA ]; then
#	setprop vendor.asus.mag.accessory $ACCESSORY_STATUS__DATA
#elif [ 4 == $ACCESSORY_STATUS__DATA ]; then
#	if [ "ID" == $COUNTRY_VAL ]; then
#		echo "Country Code is ID"
#		setprop vendor.asus.mag.accessory 32
#	else
#		echo "Country Code is not ID"
#		setprop vendor.asus.mag.accessory $ACCESSORY_STATUS__DATA
#	fi
#fi

#if [ 1 == $ACCESSORY_STATUS__DATA ]; then
#	echo "InBox Connect "
#	#setprop vendor.asus.mag.accessory 1
#elif [ 2 == $ACCESSORY_STATUS__DATA ]; then
#	echo "GamePad Connect"
#	setprop vendor.asus.mag.accessory 1
#elif [ 4 == $ACCESSORY_STATUS__DATA ]; then
#	echo "HeadPhone Connect"
#	setprop vendor.asus.mag.accessory 2
#else
#	echo "Unconnect"
#	setprop vendor.asus.mag.accessory 0
#fi
