#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-
#
# Karsten Schoeke <karsten.schoeke@geobasis-bb.de>
#
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

def perfometer_xcache_status_memory(row, check_command, perf_data):
    h = '<div class="stacked">'
    texts = []
    for i, color in [
        ( 2, "#f0b000" ),  #php
        ( 3, "#00ff80" )]: #viar
        value = float(perf_data[i][1])
        val = "%.1f%%" % value
        h += perfometer_linear(value, color)
        texts.append(str(val))
    h += '</div>'
    return " / ".join(texts), h  

perfometers["check_mk-xcache_status.memory"] = perfometer_xcache_status_memory

def perfometer_xcache_status_hits(row, check_command, perf_data):
    h = '<div class="stacked">'
    texts = []
    for i, color in [
        ( 0, "#f0b000" ),  #php
        ( 1, "#00ff80" )]: #var
        value = float(perf_data[i][1])
        val = "%.1f hits/s" % value
        h += perfometer_linear(value, color)
        texts.append(str(val))
    h += '</div>'
    return " / ".join(texts), h

perfometers["check_mk-xcache_status.hits"] = perfometer_xcache_status_hits
