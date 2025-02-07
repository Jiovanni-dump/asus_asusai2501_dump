#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
event=`getprop vendor.asus.dongleevent`
accy_gen=`getprop vendor.asus.accy.generation`
disable_inbox8_fw_update=`getprop vendor.asus.DisableInbox8Fwupdate`
disable_inbox9_fw_update=`getprop vendor.asus.DisableInbox9Fwupdate`

inbox_fwmode_path="/sys/class/leds/aura_inbox/fw_mode"
echo "[ROG_ACCY] DongleSwitch, type $type, accy_gen $accy_gen" > /dev/kmsg
retry=0
retry_tp=0
pdretry=0

function reset_accy_fw_ver(){
	setprop vendor.inbox.aura_fwver 0
	setprop vendor.asus.accy.fw_status 000000
	setprop vendor.asus.accy.fw_status2 000000
	setprop vendor.oem.asus.inboxid 0
}

# Define rmmod function
function remove_mod(){

	if [ -n "$1" ]; then
		echo "[ROG_ACCY] remove_mod $1" > /dev/kmsg
	else
		exit
	fi

	test=1
	while [ "$test" == 1 ]
	do
		rmmod $1
		ret=`lsmod | grep $1`
		if [ "$ret" == "" ]; then
			echo "[ROG_ACCY] rmmod $1 success" > /dev/kmsg
			test=0
		else
			echo "[ROG_ACCY] rmmod $1 fail" > /dev/kmsg
			test=1
			sleep 0.5
		fi
	done
}

function check_accy_fw_ver(){

	echo "[ROG_ACCY] Get Dongle FW Ver, type $type" > /dev/kmsg

	if [ "$type" == "1" ]; then
		if [ "$accy_gen" == "1" ]; then			# for factory test, it will be deleted later.
			setprop vendor.asus.accy.fw_status 000000
		else
			fw_mode=`cat /sys/class/leds/aura_inbox/fw_mode`
			echo "[ROG_ACCY] InBox fw_mode =$fw_mode " > /dev/kmsg
			if [ "$fw_mode" == "1" ]; then
				inbox_unique_id=`cat /sys/class/leds/aura_inbox/unique_id`
				setprop vendor.oem.asus.inboxid $inbox_unique_id
				inbox_aura=`cat /sys/class/leds/aura_inbox/fw_ver`
				if [ "$inbox_aura" == "0x0000" ]; then
					sleep 0.35
				fi
				inbox_aura=`cat /sys/class/leds/aura_inbox/fw_ver`
				setprop vendor.inbox.aura_fwver $inbox_aura

				# check FW need update or not
				aura_fw=`getprop vendor.asusfw.inbox.aura_fwver`
				echo "[ROG_ACCY] InBox inbox_aura = $inbox_aura  aura_fw = $aura_fw"  > /dev/kmsg
				if [ "$inbox_aura" == "$aura_fw" ]; then
					setprop vendor.asus.accy.fw_status 000000
				elif [ "$inbox_aura" == "i2c_error" ]; then
					echo "[ROG_ACCY] InBox AURA_SYNC FW Ver Error" > /dev/kmsg
					setprop vendor.asus.accy.fw_status 000000
				else
					setprop vendor.asus.accy.fw_status 100000
				fi
			elif [ "$fw_mode" == "2" ]; then
				setprop vendor.asus.accy.fw_status 100000
			else # the wrong mode
				#Todo:reset
				fw_mode=`cat /sys/class/leds/aura_inbox/fw_mode`
				if [ "$fw_mode" == "1" ]; then
					inbox_aura=`cat /sys/class/leds/aura_inbox/fw_ver`
					setprop vendor.inbox.aura_fwver $inbox_aura

					# check FW need update or not
					aura_fw=`getprop vendor.asusfw.inbox.aura_fwver`
					if [ "$inbox_aura" == "$aura_fw" ]; then
						setprop vendor.asus.accy.fw_status 000000
					elif [ "$inbox_aura" == "i2c_error" ]; then
						echo "[ROG_ACCY] InBox AURA_SYNC FW Ver Error" > /dev/kmsg
						setprop vendor.asus.accy.fw_status 000000
					else
						setprop vendor.asus.accy.fw_status 100000
					fi
				elif [ "$fw_mode" == "2" ]; then
					setprop vendor.asus.accy.fw_status 100000
				else
					echo "[ROG_ACCY] inbox fw_mode is wrong." > /dev/kmsg
				fi
			fi
		fi
	elif [ "$type" == "10" ]; then #Fandongle 8
		sleep 1

		echo "[ROG_ACCY] Wakeup MS51" > /dev/kmsg
		echo 0 > /sys/class/leds/aura_inbox/gpio11

		inbox_unique_id=`cat /sys/class/leds/aura_inbox/unique_id`
		if [ "$inbox_unique_id" != "0x000000000000000000000000" ]; then
			echo "[ROG_ACCY] set Unique ID as $inbox_unique_id" > /dev/kmsg
			setprop vendor.oem.asus.inboxid $inbox_unique_id
		else
			echo "[ROG_ACCY] skip set Unique ID as $inbox_unique_id" > /dev/kmsg
		fi

		# Get aura version
		echo 1 > /sys/class/leds/aura_inbox/ic_switch
		inbox8_aura_2led=`cat /sys/class/leds/aura_inbox/fw_ver`

		# Get pd version
		inbox8_pd=`cat /sys/class/leds/aura_inbox/pd_fw_date`

		echo "[ROG_ACCY] Fandongle 8 ver: $inbox8_aura_2led $inbox8_pd" > /dev/kmsg
		setprop vendor.inbox8.2led_fwver $inbox8_aura_2led
		setprop vendor.inbox8.pd_fwver $inbox8_pd

		# Get PCBID
		pcbid=`cat /sys/class/leds/aura_inbox/PCBID2`
		echo "[ROG_ACCY] Fandongle 8 PCBID: $pcbid" > /dev/kmsg
		setprop vendor.fandg8.pcbid	 $pcbid

		if [ "$pcbid" == "0x1" ]; then
			aura_2led_fw=`getprop vendor.asusfw.fandg8_dp.2led_fwver`
			pd_fw=`getprop vendor.asusfw.fandg8_dp.pd_fwver`
		else
			aura_2led_fw=`getprop vendor.asusfw.fandg8.2led_fwver`
			pd_fw=`getprop vendor.asusfw.fandg8.pd_fwver`
		fi

		if [ "$inbox8_pd" != "$pd_fw" ]; then
			echo "[ROG_ACCY] Should update FAN PD from $inbox8_pd to $pd_fw" > /dev/kmsg
			inbox_pd_update="1"
		else
			inbox_pd_update="0"
		fi

		inbox8_2led_fwmode=`cat /sys/class/leds/aura_inbox/fw_mode`
		if [ "$inbox8_2led_fwmode" != "1" ]; then
			echo "[ROG_ACCY] 2led in LD mode, $inbox8_2led_fwmode" > /dev/kmsg
			inbox8_2led_update="1"
		else
			if [ "$inbox8_aura_2led" != "$aura_2led_fw" ]; then
				echo "[ROG_ACCY] Should update FAN 2LED from $inbox8_aura_2led to $aura_2led_fw" > /dev/kmsg
				inbox8_2led_update="1"
			else
				inbox8_2led_update="0"
			fi
		fi

		if [ "$disable_inbox8_fw_update" == "1" ]; then
			echo "[ROG_ACCY] Inbox8 Firmware update is disable!!!!!!!" > /dev/kmsg
			setprop vendor.asus.accy.fw_status 000000
			setprop vendor.asus.accy.fw_status2 000000
		else
			setprop vendor.asus.accy.fw_status "$inbox8_2led_update"0"$inbox_pd_update"000
			setprop vendor.asus.accy.fw_status2 000000
		fi
elif [ "$type" == "11" ]; then #Fandongle 9
		sleep 1

		echo "[ROG_ACCY] Wakeup MS51" > /dev/kmsg
		echo 1 > /sys/class/leds/aura_inbox/HDC2010_HS_INT

		inbox_unique_id=`cat /sys/class/leds/aura_inbox/unique_id`
		if [ "$inbox_unique_id" != "0x000000000000000000000000" ]; then
			echo "[ROG_ACCY] set Unique ID as $inbox_unique_id" > /dev/kmsg
			setprop vendor.oem.asus.inboxid $inbox_unique_id
		else
			echo "[ROG_ACCY] skip set Unique ID as $inbox_unique_id" > /dev/kmsg
		fi

		# Get aura version
		echo 1 > /sys/class/leds/aura_inbox/ic_switch
		inbox9_aura_2led=`cat /sys/class/leds/aura_inbox/fw_ver`

		# Get pd version
		inbox9_pd=`cat /sys/class/leds/aura_inbox/pd_fw_date`

		echo "[ROG_ACCY] Fandongle 9 ver: $inbox9_aura_2led $inbox9_pd" > /dev/kmsg
		setprop vendor.inbox9.2led_fwver $inbox9_aura_2led
		setprop vendor.inbox9.pd_fwver $inbox9_pd

		# Get PCBID
		pcbid=`cat /sys/class/leds/aura_inbox/PCBID2`
		echo "[ROG_ACCY] Fandongle 9 PCBID: $pcbid" > /dev/kmsg

		aura_2led_fw=`getprop vendor.asusfw.fandg9.2led_fwver`
		pd_fw=`getprop vendor.asusfw.fandg9.pd_fwver`


		if [ "$inbox9_pd" != "$pd_fw" ]; then
			echo "[ROG_ACCY] Should update FAN PD from $inbox9_pd to $pd_fw" > /dev/kmsg
			inbox_pd_update="1"
		else
			inbox_pd_update="0"
		fi

		inbox9_2led_fwmode=`cat /sys/class/leds/aura_inbox/fw_mode`
		if [ "$inbox9_2led_fwmode" != "1" ]; then
			echo "[ROG_ACCY] 2led in LD mode, $inbox9_2led_fwmode" > /dev/kmsg
			inbox9_2led_update="1"
		else
			if [ "$inbox9_aura_2led" != "$aura_2led_fw" ]; then
				echo "[ROG_ACCY] Should update FAN 2LED from $inbox9_aura_2led to $aura_2led_fw" > /dev/kmsg
				inbox9_2led_update="1"
			else
				inbox9_2led_update="0"
			fi
		fi

		if [ "$disable_inbox9_fw_update" == "1" ]; then
			echo "[ROG_ACCY] Inbox9 Firmware update is disable!!!!!!!" > /dev/kmsg
			setprop vendor.asus.accy.fw_status 000000
			setprop vendor.asus.accy.fw_status2 000000
		else
			setprop vendor.asus.accy.fw_status "$inbox9_2led_update"0"$inbox_pd_update"000
			setprop vendor.asus.accy.fw_status2 000000
		fi
	fi

	# initial autosuspend delay
	autosuspend_delay_ms=`getprop vendor.asus.autosuspend.delayms`
	echo $autosuspend_delay_ms > /sys/bus/usb/devices/2-1.1/power/autosuspend_delay_ms
	echo "[ROG_ACCY] set inbox autosuspend delay as $autosuspend_delay_ms ms" > /dev/kmsg

	fw_status=`getprop vendor.asus.accy.fw_status`
	fw_status2=`getprop vendor.asus.accy.fw_status2`

	echo "[ROG_ACCY] fw_status $fw_status, fw_status2 $fw_status2" > /dev/kmsg
	#echo "[ROG_ACCY] Get Dongle FW Ver done." > /dev/kmsg
}

if [ "$type" == "0" ]; then
	exit

elif [ "$type" == "1" ]; then
	echo "[ROG_ACCY][Switch] InBox" > /dev/kmsg

	if [ "$accy_gen" == "1" ]; then			# For JEDI dongle
		echo "[ROG_ACCY][Switch] This is ROG1 Inbox" > /dev/kmsg
	elif [ "$accy_gen" == "2" ]; then		# For YODA dongle
		echo "[ROG_ACCY][Switch] This is ROG2 Inbox" > /dev/kmsg
	elif [ "$accy_gen" == "3" ]; then		# For OBIWAN dongle
		echo "[ROG_ACCY][Switch] This is ROG3 Inbox" > /dev/kmsg
	elif [ "$accy_gen" == "5" ]; then		# For ANAKIN dongle
		echo "[ROG_ACCY][Switch] This is ROG5 Inbox" > /dev/kmsg
	else
		echo "[ROG_ACCY][Switch] Generation wrong, $accy_gen!!!!" > /dev/kmsg
		exit 0
	fi

	# Detect Inbox driver sysfs node
	if [ ! -f "$inbox_fwmode_path" ]; then
		echo "[ROG_ACCY][Switch] Inbox driver occur error!!! Maybe it is not 5nd inbox." > /dev/kmsg
		exit 0
	fi

	# Close Phone aura
	#echo 0 > /sys/class/leds/aura_sync/mode
	#echo 1 > /sys/class/leds/aura_sync/apply
	#echo 0 > /sys/class/leds/aura_sync/VDD

	# do not add any action behind here
	setprop vendor.asus.donglechmod 1
	check_accy_fw_ver;

elif [ "$type" == "10" ]; then
	echo "[ROG_ACCY][Switch] FANDG 8" > /dev/kmsg
	# do not add any action behind here
	setprop vendor.asus.donglechmod 10
	fan_pjid=`cat /sys/class/leds/aura_inbox/get_FAN_PJID`
	setprop vendor.asus.fan_pjid $fan_pjid	
	check_accy_fw_ver;
	start rpm_monitor

elif [ "$type" == "11" ]; then
	echo "[ROG_ACCY][Switch] FANDG 9" > /dev/kmsg
	# do not add any action behind here
	setprop vendor.asus.donglechmod 11
	fan_pjid=`cat /sys/class/leds/aura_inbox/get_FAN_PJID`
	setprop vendor.asus.fan_pjid $fan_pjid
	check_accy_fw_ver
	start rpm_monitor	
else
	echo "[ROG_ACCY][Switch] Error Type $type" > /dev/kmsg
fi
