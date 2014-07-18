#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-
#
# 2013 Karsten Schoeke karsten.schoeke@geobasis-bb.de

group = "checkparams"

subgroup_os =           _("Operating System Resources")

register_check_parameters(
    subgroup_os,
    "apt",
    _("APT Update check"),
        None,
        None, None
)
