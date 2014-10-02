<?php

$opt[1] = "--vertical-label \"Celsius\"  -l 0 -u 70 --title \"$hostname / $servicedesc\" ";

$def[1] = "DEF:var1=$RRDFILE[1]:$DS[1]:MAX ";
$def[1] .= "AREA:var1#2080ff:\"Temperature\:\" ";
$def[1] .= "GPRINT:var1:LAST:\"%2.0lf °C\" ";
$def[1] .= "LINE1:var1#000080:\"\" ";
$def[1] .= "GPRINT:var1:MAX:\"(Max\: %2.0lf °C,\" ";
$def[1] .= "GPRINT:var1:AVERAGE:\"Avg\: %2.0lf °C)\" ";
if ($WARN[1] != "") {
    $def[1] .= "HRULE:$WARN[1]#FFFF00:\"Warning\: $WARN[1] °C\" ";
    $def[1] .= "HRULE:$CRIT[1]#FF0000:\"Critical\: $CRIT[1] °C\" ";
}
?>
