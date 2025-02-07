#!/system/bin/sh

echo "PCBID TEST: +++"

rm /data/data/pcbid_status_str_tmp

PROP_STAGE=$(getprop ro.boot.id.stage)
PROP_PROJECT=$(getprop ro.boot.id.prj)
PROP_LGF_CON_ID_2=$(getprop ro.boot.id.lgf_con_2)

STAGE=
PROJECT=

case $PROP_PROJECT in
	"0" | "1" )
		if [ "$PROP_LGF_CON_ID_2" -eq "0" ]; then
			PROJECT='AI2501_Chicago_Entry'
			echo "PCBID TEST: PROJECT="$PROJECT
		elif [ "$PROP_LGF_CON_ID_2" -eq "1" ]; then
			PROJECT='AI2501_Chicago_Pro'
			echo "PCBID TEST: PROJECT="$PROJECT
		else
			PROJECT='UNKNOW('$PROP_PROJECT')'
			echo "PCBID TEST: PROJECT="$PROJECT
		fi
		;;
	"2" )
		PROJECT='AI2501_Hawaii'
		echo "PCBID TEST: PROJECT="$PROJECT
		;;
	 *  )
		PROJECT='UNKNOW('$PROP_PROJECT')'
		echo "PCBID TEST: PROJECT="$PROJECT
		;;
esac

if [ "$PROP_PROJECT" -eq "2" ]; then #Hawaii
	case $PROP_STAGE in
		"3" )
			STAGE='SR'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"4" )
			STAGE='ER'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"5" )
			STAGE='PR'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"7" )
			STAGE='MP'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		*)
			STAGE='UNKNOW('$PROP_STAGE')'
			echo "PCBID TEST: STAGE="$STAGE
			;;
	esac
else #Chicago
	case $PROP_STAGE in
		"0" )
			STAGE='EVB'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"1" )
			STAGE='SR1'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"2" )
			STAGE='SR2'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"3" )
			STAGE='ER1'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"4" )
			STAGE='ER2'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"5" )
			STAGE='PR'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		"7" )
			STAGE='MP'
			echo "PCBID TEST: STAGE="$STAGE
			;;
		*)
			STAGE='UNKNOW('$PROP_STAGE')'
			echo "PCBID TEST: STAGE="$STAGE
			;;
	esac
fi

echo $PROJECT"_"$STAGE > /data/data/pcbid_status_str_tmp
chmod 00777 /data/data/pcbid_status_str_tmp

echo "PCBID TEST: ---"
