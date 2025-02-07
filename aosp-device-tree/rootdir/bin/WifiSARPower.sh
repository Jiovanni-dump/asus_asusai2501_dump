ReceiverOn=`getprop log.asus.sar.audio`
Wifion=`getprop wlan.driver.status`
Country=`getprop vendor.asus.operator.iso-country`
CameraReduce=`getprop vendor.camera.WifiInfo`
#SKU=`getprop ro.boot.id.prj`
#CustomerID=`getprop ro.config.CID`
WWANon=`getprop vendor.ril.tel.mobiledata`
Softapon=`getprop vendor.wlan.softap.driver.status`
#WlanDbs=`getprop vendor.wlan.dbs`
Slm=`getprop vendor.sla.enabled`

log -t WifiSARPower enter Wifion=$Wifion Country=$Country ReceiverOn=$ReceiverOn Softapon=$Softapon Slm=$Slm WWANon=$WWANon CameraReduce=$CameraReduce

if [ "$Country" == "US" ] || [ "$Country" == "CA" ] || [ "$Country" == "BR" ]; then
    if [ "$CameraReduce" == "1" ] ; then
        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

        log -t WifiSARPower CameraReduce US/CA/BR case B, reduce to 4dB
    elif [ "$CameraReduce" == "2" ]; then
        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD

        log -t WifiSARPower CameraReduce US/CA/BR case C, reduce to 0dB
    else
        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 2 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 2 --END_ATTR --END_ATTR --END_CMD

        log -t WifiSARPower US/CA/BR
    fi
elif [ "$CameraReduce" == "1" ] ; then
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 3 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 3 --END_ATTR --END_ATTR --END_CMD

    log -t WifiSARPower CameraReduce case B, reduce to 4dB
elif [ "$CameraReduce" == "2" ]; then
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 4 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 4 --END_ATTR --END_ATTR --END_CMD

    log -t WifiSARPower CameraReduce case C, reduce to 0dB
else
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 5 --NUM_SPECS 0 --END_CMD

    log -t WifiSARPower Not tirgger
fi
