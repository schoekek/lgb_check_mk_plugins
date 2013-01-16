#!/bin/bash

DROP=$(iptables -L |grep -c "policy DROP")

if [ $DROP -eq 3 ]
then
        status=0
        statustxt=OK
elif [ $DROP -gt 0 ]
then
        status=1
        statustxt=WARNING
elif [ $DROP -eq 0 ]
then
        status=2
        statustxt=CRITICAL

else
        status=3
        statustxt=UNKNOWN
fi
        ANZ=$(iptables -S|egrep -e "^-A.*"|wc -l)
        echo "$status FIREWALL - $statustxt - $ANZ firewall rules detected"
