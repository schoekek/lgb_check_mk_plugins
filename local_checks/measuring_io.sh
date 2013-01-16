NZ_CPU=$(($(cat /proc/cpuinfo | grep processor| wc -l)-1))
for CPU in $(seq 0 $ANZ_CPU)
do
        FILE=/tmp/cpu.number${CPU}
        FILE_tmp=/tmp/cpu.tmp.number${CPU}
        CORE="cpu${CPU}"
        if [ ! -f $FILE ]
        then
                grep $CORE /proc/stat |awk '{print $2+$3+$4+$5+$6+$7" "$6}' > $FILE
                sleep 1
        fi
        mv $FILE $FILE_tmp
        grep $CORE /proc/stat |awk '{print $2+$3+$4+$5+$6+$7" "$6}' > $FILE
        RANGE=$(($(cat $FILE| cut -f1 -d " ")-$(cat $FILE_tmp| cut -f1 -d " ") ))
        DAUER=$(($(cat $FILE| cut -f2 -d " ")-$(cat $FILE_tmp| cut -f2 -d " ") ))
        IO=$(echo "$RANGE $DAUER"|awk '{printf "%0.0f",  $2/$1*100 }')

        if [ $IO -gt 90 ]
        then
                status=2
                statustxt=CRITICAL
        elif [ $IO -gt 50 ]
        then
                status=1
                statustxt=WARNING
        elif [ $IO -gt 0 ] || [ $IO -eq 0 ]
        then
                status=0
                statustxt=OK
        else
                status=3
                statustxt=UNKNOWN
        fi
        echo "$status ${CORE}_IO_WAIT iowait_0=${IO};50;90;0;100 $statustxt - ${IO}% IO WAIT @ $CORE"
done
