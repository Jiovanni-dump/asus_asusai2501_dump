#!/vendor/bin/sh

#echo $0 > /dev/kmsg
echo "ASDF: Check LastShutdown log." > /dev/kmsg

function minidparse_TZ_XBL() {
	#Parse "md_TZ_IMEM.BIN" "md_XBL_LOG.BIN" from ftm to asdf folder
	tmp=$(/vendor/bin/minidparse "md_TZ_IMEM.BIN" "md_XBL_LOG.BIN")
	echo "TZ/XBL Log info:$tmp" > /proc/asusevtlog

	#For NOC check
	if test -e /asdf/md_TZ_IMEM.BIN; then
		nocvar=$(cat /asdf/md_TZ_IMEM.BIN | grep -iE '\[.*\]\(.*NOC|\[.*\].*SPMI bus busy')
		if [[ -n ${nocvar} ]];then
			#Save NOC log to last_kmsg
			cat /asdf/md_TZ_IMEM.BIN | grep -iE '\[.*\]\(|\[.*\].*SPMI bus busy' >> /asdf/last_kmsg
			#known issue pre-parse
			known_issue=0
			#1. mdsp noc issue
			nocvar=$(cat /asdf/last_kmsg | grep -iE '\[.*\]\(.*GEM_NOC 4 1 450e19')
			if [[ -n ${nocvar} ]];then
				echo "##asusparse##:modem:noc" >> /asdf/last_kmsg
				known_issue=1
			fi
			#2. pmic settling error/AOP
			nocvar=$(cat /asdf/last_kmsg | grep -ciE '\[.*\].*SPMI bus busy')
			if [ ${nocvar} -gt 5 ]; then
				echo "##asusparse##:pmic:noc" >> /asdf/last_kmsg
				known_issue=1
			fi
			#N. unknown noc issue
			if [ $known_issue -eq 0 ]; then
				echo "##asusparse##:unknown:noc" >> /asdf/last_kmsg
			fi
		fi
		rm /asdf/md_TZ_IMEM.BIN
	fi

	#For XBL/UEFI log check
	if test -e /asdf/md_XBL_LOG.BIN; then
		#known issue pre-parse
		#1. pmic ocp issue
		nocvar=$(cat /asdf/md_XBL_LOG.BIN | grep -iE 'OCP Occured')
		if [[ -n ${nocvar} ]];then
			#Save XBL log to last_kmsg
			cat /asdf/md_XBL_LOG.BIN | grep -E '^D\ -\ |^B\ -\ |\[ABL\]|^S\ -\ ' >> /asdf/last_kmsg
			echo "##asusparse##:pmic:ocp" >> /asdf/last_kmsg
		fi
		rm /asdf/md_XBL_LOG.BIN
	fi
}

#######################################################################################################
#Check if there is an abnormal shutdown occured
dd if=/dev/block/bootdevice/by-name/ftm of=/data/vendor/logcat_log/miniramdump_header.txt bs=4 count=2
var=$(cat /data/vendor/logcat_log/miniramdump_header.txt)
if test "$var" = "Raw_Dmp!"
then
	fext="$(date +%Y%m%d-%H%M%S).txt"
	/vendor/bin/minidparse "md_KLOGDMSG.BIN"
	cp /asdf/md_KLOGDMSG.BIN /asdf/LastShutdownCrash.txt
	cp /asdf/md_KLOGDMSG.BIN /asdf/last_kmsg
	chmod 666 /asdf/last_kmsg
	chown system:system /asdf/last_kmsg
	rm /asdf/md_KLOGDMSG.BIN

	echo "ASDF: Found Mini Dump!" > /proc/asusevtlog
	echo "MiniDump" > /data/vendor/logcat_log/miniramdump_header.txt
	dd if=/data/vendor/logcat_log/miniramdump_header.txt of=/dev/block/bootdevice/by-name/ftm bs=4 count=2
	rm /data/vendor/logcat_log/miniramdump_header.txt

	echo "ASDF: Parsing minidump for SOC" > /dev/kmsg
	minidparse_TZ_XBL
else
	# Remove old logs
	if [ -e /asdf/last_kmsg ]; then
		rm /asdf/last_kmsg
	fi
fi

rawdump_enable=`getprop ro.boot.rawdump_en`
if [ "${rawdump_enable}" = "1" ]; then
	dd if=/dev/block/bootdevice/by-name/rawdump of=/data/vendor/logcat_log/ramdump_header.txt bs=4 count=2
	var=$(cat /data/vendor/logcat_log/ramdump_header.txt)
	if test "$var" = "Raw_Dmp!"
	then
		echo "ASDF: Found Full Dump!" > /dev/kmsg
	fi
fi

#######################################################################################################
# Check PMIC PON log
reason=$(cat /proc/asusdebug-ponpoff)
reason_fault=$(cat /proc/asusdebug-ponpoff | grep -iE 'PMIC_RB|FAULT_N|SMPL|UVLO|RESTART_PON')
RECORD_TIME=`date "+%Y/%m/%d %H:%M:%S"`
if [[ -n ${reason} ]];then
	echo "${reason} @${RECORD_TIME}" > /asdf/pmic_pon.txt
	if [[ -n ${reason_fault} ]];then
		echo "${reason} @${RECORD_TIME}" > /asdf/FAULT_REASON
		chmod 666 /asdf/FAULT_REASON
		chown system:system /asdf/FAULT_REASON
		cp /asdf/FAULT_REASON /asdf/Last_PMIC_PON.txt
		chmod 666 /asdf/Last_PMIC_PON.txt
		chown system:system /asdf/Last_PMIC_PON.txt
	else
		# Remove old log
		if [ -e /asdf/FAULT_REASON ]; then
			rm /asdf/FAULT_REASON
		fi
	fi
fi

#echo "$0 EXIT" > /dev/kmsg
