#!/vendor/bin/sh
result=$(/vendor/bin/grip_get_vendor.sh)
if [ "$result" == "ndt" ]; then
	/vendor/bin/grip_fpc_check_ndt.sh
else
	/vendor/bin/grip_fpc_check_snt.sh
fi
