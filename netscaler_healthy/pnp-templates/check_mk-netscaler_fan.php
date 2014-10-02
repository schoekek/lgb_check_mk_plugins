<?php
#
$opt[1] = "--vertical-label \"rpm\" --title \"$hostname / $servicedesc\" ";

$def[1] = "DEF:var1=$RRDFILE[1]:$DS[1]:MAX ";
$def[1] .= "AREA:var1#2080ff:\"Speed\:\" ";
$def[1] .= "GPRINT:var1:LAST:\"%2.0lf rpm\" ";
$def[1] .= "LINE1:var1#000080:\"\" ";
$def[1] .= "GPRINT:var1:MAX:\"(Max\: %2.0lf rpm,\" ";
$def[1] .= "GPRINT:var1:AVERAGE:\"Avg\: %2.0lf rpm)\" ";
?>
