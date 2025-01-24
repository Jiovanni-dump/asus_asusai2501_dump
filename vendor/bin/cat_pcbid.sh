#!/system/bin/sh
PROP_STAGE=$(getprop ro.boot.id.stage)
PROP_PROJECT=$(getprop ro.boot.id.prj)
PROP_LGF_CON_ID_2=$(getprop ro.boot.id.lgf_con_2)

STAGE=
PROJECT=

case $PROP_PROJECT in
	"0" | "1" )
		if [ "$PROP_LGF_CON_ID_2" -eq "0" ]; then
			PROJECT='AI2501_Chicago_Entry'
		elif [ "$PROP_LGF_CON_ID_2" -eq "1" ]; then
			PROJECT='AI2501_Chicago_Pro'
		else
			PROJECT='UNKNOW('$PROP_PROJECT')'
		fi
		;;
	"2" )
		PROJECT='AI2501_Hawaii'
		;;
	 *  )
		PROJECT='UNKNOW('$PROP_PROJECT')'
		;;
esac

if [ "$PROP_PROJECT" -eq "2" ]; then #Hawaii
	case $PROP_STAGE in
		"3" )
			STAGE='SR'
			;;
		"4" )
			STAGE='ER'
			;;
		"5" )
			STAGE='PR'
			;;
		"7" )
			STAGE='MP'
			;;
		*)
			STAGE='UNKNOW('$PROP_STAGE')'
			;;
	esac
else #Chicago
	case $PROP_STAGE in
		"0" )
			STAGE='EVB'
			;;
		"1" )
			STAGE='SR1'
			;;
		"2" )
			STAGE='SR2'
			;;
		"3" )
			STAGE='ER1'
			;;
		"4" )
			STAGE='ER2'
			;;
		"5" )
			STAGE='PR'
			;;
		"7" )
			STAGE='MP'
			;;
		*)
			STAGE='UNKNOW('$PROP_STAGE')'
			;;
	esac
fi

echo $PROJECT"_"$STAGE
