#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

def perfometer_check_mk_cp_fw_con(row, check_command, perf_data):
    color = { 0: "#a4f", 1: "#ff2", 2: "#f22", 3: "#fa2" }[row["service_state"]]
    return "%d" % int(perf_data[0][1]), perfometer_logarithmic(perf_data[0][1], 10000, 2, color)

perfometers["check_mk-cp_fw_con"] = perfometer_check_mk_cp_fw_con

