#!/usr/bin/python    
# -*- encoding: utf-8; py-indent-offset: 4 -*-
#
# 2014 Karsten Schoeke karsten.schoeke@geobasis-bb.de

#memory
register_check_parameters(
    subgroup_applications,
    "xcache_mem",
    _("XCache Memory levels"),
    Dictionary(
        elements = [
            ( "mem_php",
                Tuple(
                    title = _("level for php Cache Memory"),
                    elements = [
                        Percentage(title = _("Warning if above"), label = _("% usage")),
                        Percentage(title = _("Critical if above"), label = _("% usage")), 
                    ]
                ),
            ),
            ( "mem_var",
                Tuple(
                    title = _("level for variables Cache Memory"),
                    elements = [
                        Percentage(title = _("Warning if above"), label = _("% usage")),
                        Percentage(title = _("Critical if above"), label = _("% usage")),
                    ]
                ),
            ),
        ]),
    None,
    "dict"
)

#hits
register_check_parameters(
    subgroup_applications,
    "xcache_hits",
    _("XCache Cache levels"),
    Dictionary(
        elements = [
            ( "misses_php",
                Tuple(
                    title = _("level for php Cache Misses, miss is requested but not in the cache"),
                    elements = [
                        Integer(title = _("Warning above"), unit = _("misses hits")),
                        Integer(title = _("Critical above"), unit = _("misses hits")),
                    ]
                ),
            ),
            ( "misses_var",
                Tuple(
                    title = _("level for var Cache Misses, miss is requested but not in the cache"),
                    elements = [
                        Integer(title = _("Warning above"), unit = _("misses hits")),
                        Integer(title = _("Critical above"), unit = _("misses hits")),
                    ]
                ),
            ),
        ]),
    None,
    "dict"
)

