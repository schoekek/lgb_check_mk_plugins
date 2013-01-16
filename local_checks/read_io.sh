ES="sda1 sdb5"

function gen_return_perc () {
        # gen_return_perc WERT WARN CRIT MIN MAX VariablenName ServiceName Definiation
        WERT=$(($1))
        WARN=$(($2))
        CRIT=$(($3))
        MIN=$(($4))
        MAX=$(($5))
        VAR="$6"
        NAME="$7"
        DEF="$8"
        if [ $WERT -gt $CRIT ]
        then
                status=2
                statustxt=CRITICAL
        elif [ $WERT -gt $WARN ]
        then
                status=1
                statustxt=WARNING
        elif [ $WERT -gt 0 ] || [ $WERT -eq 0 ]
        then
                status=0
                statustxt=OK
        else
                status=3
                statustxt=UNKNOWN
        fi
        echo "$status $NAME ${VAR}=${WERT};${WARN};${CRIT};${MIN};${MAX} $statustxt - $DEF"
}
for DEV in $DEVICES
do
        FILE=/dev/shm/disk.${DEV}
        FILE_tmp=/dev/shm/disk.tmp.${DEV}
        LAST=/dev/shm/last.${DEV}
        LAST_tmp=/dev/shm/last.tmp.${DEV}
        if [ ! -f $FILE ];then  grep ${DEV} /proc/diskstats > $FILE; sleep 1;fi
        if [ ! -f $LAST ];then  date +%s > $LAST; sleep 1;fi
        mv $FILE $FILE_tmp
        mv $LAST $LAST_tmp
        grep ${DEV} /proc/diskstats > $FILE
        date +%s > $LAST
        START=($(cat $FILE_tmp))
        ENDE=($(cat $FILE))
        DAUER=$(($(cat $LAST)-$(cat $LAST_tmp)))
        IOP=$((${ENDE[3]}-${START[3]}+${ENDE[7]}-${START[7]}))
        IO_SPENT=$((${ENDE[12]}-${START[12]}))
        IO_OVER=$((${ENDE[13]}-${START[13]}))
        MOUNT=$(df -h /dev/${DEV} | tail -1| awk '{print $6}')
        if [ $IOP -eq 0 ]; then
                AVG=0
                DISK_AVG=0
        else
                AVG=$(echo "$IOP $IO_SPENT $DAUER"|awk '{printf "%d", $2/$1/$3 }')
                AVG=$(($IO_SPENT/$IOP))
                DISK_AVG=$(echo "$IOP $IO_SPENT"|awk '{printf "%2.2f", $2/$1 }')
        fi
        if [ $IO_SPENT -lt 1000 ]; then
                IOPS=0
                DISK_IOPS=0
        else
                #IOPS=$(echo "$IOP $IO_SPENT $DAUER"|awk '{printf "%d", $1/($2/1000)/$3 }')
                DISK_IOPS=$(echo "$IOP $IO_SPENT $DAUER"|awk '{printf "%2.4f", $1/($2/1000) }')
                IOPS=$(($IOP/($IO_SPENT/1000)))
        fi
        if [ $IO_OVER -lt $((1000*$DAUER)) ]; then
                IO_OVER=0
        else
                #IO_OVER=$(echo "$IO_OVER $DAUER"|awk '{printf "%d", $1-(1000*$DAUER) }')
                IO_OVER=$(($IO_OVER-(1000*$DAUER)))
        fi
        if [ $IO_SPENT -gt $((1000*$DAUER)) ]; then IO_SPENT=$((1000*$DAUER));fi
        DISK_UTIL=$(echo "$IO_SPENT $DAUER"|awk '{printf "%2.2f %% ",  $1/10/$2 }')
        DISK_OVERLOAD=$(echo "$IO_OVER $DAUER"|awk '{printf "%2.2f %% ",  $1/10/$2 }')
        gen_return_perc $(($IO_SPENT/10/$DAUER)) 50 90 0 100 Prozent DISK_${DEV}_UTIL " Auslastung von $DEV ($MOUNT) : $DISK_UTIL"
        gen_return_perc $(($IO_OVER/10/$DAUER)) 100 150 0 100 Prozent DISK_${DEV}_OVERLOAD " geschäte Üerlastung von $DEV ($MOUNT) : $DISK_OVERLOAD"
        gen_return_perc $(($AVG)) 15 20 0 20 Zugriffszeit DISK_${DEV}_AVG " Durchschnitt Zugriffszeit auf $DEV ($MOUNT) : $DISK_AVG ms"
        gen_return_perc $(($IOPS)) 400 500 0 200 IOPS DISK_${DEV}_IOPS " Durchschnitt In/Out Operationen pro sec auf $DEV ($MOUNT) : $IOPS"

done
