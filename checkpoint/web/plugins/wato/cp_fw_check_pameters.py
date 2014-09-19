#!/usr/bin/python    
# -*- encoding: utf-8; py-indent-offset: 4 -*-
#
# 2013 Karsten Schoeke karsten.schoeke@geobasis-bb.de

#group = "checkparams"

#subgroup_networking =   _("Networking")

register_check_parameters(
    subgroup_networking,
    "cp_fw_con",
    _("Checkpoint Connection levels"),
    Dictionary(
        elements = [
            ( "con",
                Tuple(
                    title = _("level for Connection count"),
                    help = _("Put here the levels for connections on checkpoint firewall."),           
                    elements = [
                        Integer(title = _("Warning at")),
                        Integer(title = _("Critical at")),
                    ]
                ),
            ),
        ]),
    None,
    "dict"
)
