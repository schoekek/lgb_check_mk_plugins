<?php
# check_mk is free software;  you can redistribute it and/or modify it
# under the  terms of the  GNU General Public License  as published by
# the Free Software Foundation in version 2.  check_mk is  distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY;  with-
# out even the implied warranty of  MERCHANTABILITY  or  FITNESS FOR A
# PARTICULAR PURPOSE. See the  GNU General Public License for more de-
# ails.  You should have  received  a copy of the  GNU  General Public
# License along with GNU Make; see the file  COPYING.  If  not,  write
# to the Free Software Foundation, Inc., 51 Franklin St,  Fifth Floor,
# Boston, MA 02110-1301 USA.


$opt[1] = "--vertical-label 'MB' -l 0  --title '$hostname / $servicedesc: php and var memory levels' ";
$def[1] = ""
         . "DEF:php=$RRDFILE[1]:$DS[1]:MAX "
         . "DEF:var=$RRDFILE[2]:$DS[1]:MAX "
         . "CDEF:min_var=0,var,- "
         . "CDEF:total=php,var,+ "
         . "AREA:php#00c0ff:\"php\" ";
if ($MAX[1]) {
    $def[1] .= "LINE1:$MAX[1]#003077:\"php MAX\" "
            . "COMMENT:\"\\n\" ";
}
if ($CRIT[1]) {
  $def[1] .= "LINE1:$WARN[1]#a0ad00:\"php WARN\" "
           . "LINE1:$CRIT[1]#ad0000:\"php CRIT\" "
           . "COMMENT:\"\\n\" ";
}

$def[1] .= "AREA:min_var#3430bf:\"var\" ";
if ($MAX[2]) {
    $def[1] .= "LINE1:-$MAX[2]#003233:\"var MAX \" "
            . "COMMENT:\"\\n\" ";
}
if ($CRIT[2]) {
  $def[1] .= "LINE1:-$WARN[2]#adfd30:\"var WARN\" "
           . "LINE1:-$CRIT[2]#ff0080:\"var CRIT\" "
           . "COMMENT:\"\\n\" ";
}

$def[1] .= "GPRINT:total:LAST:\"Total %.2lfMB last\" "
         . "GPRINT:total:AVERAGE:\"%.2lfMB avg\" "
         . "GPRINT:total:MAX:\"%.2lfMB max \" " . " "
         . "COMMENT:\"\\n\" ";

?>
