#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-
#
# 2015 Karsten Schoeke karsten.schoeke@geobasis-bb.de

register_check_parameters(
    subgroup_applications,
    "ssllabs_grade",
    _("ssllabs scan checks"),
    Dictionary(
        elements = [
            ("score",
                Tuple(
                    title = _("grade level for ssllabs scan"),
                    help = _("Put here the Integerttern (regex) for ssllabs grade check level."),
                    elements = [
                        RegExpUnicode(title = _("Pattern (regex) Ok level"), default_value = "A"),
                        RegExpUnicode(title = _("Pattern (regex) Warning level"), default_value = "B|C"),
                        RegExpUnicode(title = _("Pattern (regex) Critical level"), default_value = "D|E|F|M|T"),
                    ]
                ),
            ),
            ("age",
                Tuple(
                    title = _("Maximum age of ssllabs scan"),
                    help = _("The maximum age of the last ssllabs check."),
                    elements = [
                        Age(title = _("Warning at")),
                        Age(title = _("Critical at")),
                    ]
                ),
            ),
        ]
    ),
    TextAscii( title=_("domainname of ssl cert"),
    help=_("The fqdn on ssl cert to check")),
    "first",
)

