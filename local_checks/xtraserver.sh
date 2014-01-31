#!/bin/bash
#
# check_mk local check zum Auslesen der xtraserver mon Schnittstellen
# Ausgabe der Schittstelle z.Z.:
#
# Status: OK
# Message: XtraServer is OK.
# Threads: 2
# MemoryUsage: 319508480
#


# Karsten Schöke <karsten.schoeke@geobasis-bb.de>
# Version: 0.1 17.09.2013

# Todo:
# - params für Grenzwerte in Variablen 
#   Auslesen der Grenzwerte aus service-monitor.properties
# - automatisches auslesen der Instanzen und befüllen des Array
#   analog for s in $(ls /etc/init.d/xtraserver-*); do sudo $s restart; done
#   aber über config Verzeichnis

#Parameter

# Array mit allen mon Instanzen
# Format: wie in url verwendet
#         z.B. alkis WMS 
#         alkis/wms --> http://localhost/aaa-suite/cgi-bin/alkis/wms/
#
INSTANZEN="webatlas-dyn flur webatlas alkis/wms alkis/wms-e alkis/nas-e-geobroker alkis/nas-e alkis/sf alkis/sf-e alkis/nas alkis/ins-dl alkis/ins-view afis/extern afis/intern atkis-dlm50/nas atkis-dlm50/sf atkis-bdlm/nas atkis-bdlm/sf atkis-ins-view atkis-bdlm/ins-dl atkis-dlm50/ins-dl"

# url segmente für request URL_PREFIX+INSTANZ+URL_SUFFIX
URL_PREFIX="http://localhost/aaa-suite/cgi-bin/"
URL_SUFFIX="/mon?REQUEST=GetStatus&PASSWORD=XSV-AAA-WFS"

function gen_return_perc () {
    # Werte: WERT WARN CRITICAL MIN MAX VariablenName ServiceName Statusmessage xtraserverStatus
    WERT=$(($1))
    WARN=$(($2))
    CRIT=$(($3))
    MIN=$(($4))
    MAX=$(($5))
    VAR="$6"
    NAME="$7"
    DEF="$8"
    STAT="$9"

    if [ $WERT -gt $CRIT ]
    then
        status=2
        statustxt=CRITICAL
    elif [ $WERT -gt $WARN ] || [ "$STAT" == "WARNING" ]
    then
        status=1
        statustxt=WARNING
    elif [ $WERT -ge 0 ] && [ "$STAT" == "OK" ]
    then
        status=0
        statustxt=OK
    else
        status=3
        statustxt=UNKNOW
    fi
    echo "$status $NAME ${VAR}=${WERT};${WARN};${CRIT};${MIN};${MAX} $statustxt - ${WERT} $DEF"
}

for INSTANZ in $INSTANZEN
do
    # echo " ++++ ${INSTANZ} ++++"
    MON="$(wget -qO- $URL_PREFIX$INSTANZ$URL_SUFFIX 2>&1)"
    STAT="WARNING"
    MESSAGE=""
    echo "$MON" | while read item
    do
        IDENTIFIER=$(echo $item| cut -s -d':' -f1)
        VALUE=$(echo $item| cut -s -d':' -f2)
        DIENST=$(echo ${INSTANZ/\//-})
        if [ "$IDENTIFIER" == "Status" ]
        then
            STAT=$VALUE
        elif [ "$IDENTIFIER" == "Message" ]
        then
            MESSAGE=$VALUE
        elif [ "$IDENTIFIER" == "Threads" ]
        then
            gen_return_perc $VALUE 54 60 0 0 count "xtraserver_Threads_${DIENST}" "active xtraserver Threads, ${MESSAGE}" $STAT
        elif [ "$IDENTIFIER" == "MemoryUsage" ]
        then
            gen_return_perc ${VALUE}/1024/1024 2048 3000 0 3072 memoryused "xtraserver_MemoryUsage_${DIENST}" "MB xtraserver Memory Usage, ${MESSAGE}" $STAT
        fi
    done
done
