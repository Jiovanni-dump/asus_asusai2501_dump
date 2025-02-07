#!/vendor/bin/sh

setprop vendor.asus.sys.asus_super_hash 0
setprop vendor.asus.sys.asus_super_hash_status calculating

super_hash=`sha256sum /dev/block/by-name/super |cut -d " " -f 1`

setprop vendor.asus.sys.asus_super_hash $super_hash
setprop vendor.asus.sys.asus_super_hash_status idle

