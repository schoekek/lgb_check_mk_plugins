#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

register_rulegroup("datasource_programs",
    _("Datasource Programs"),
    _("Specialized agents, e.g. check via SSH, ESX vSphere, SAP R/3"))
group = "datasource_programs"

register_rule(group,
    "special_agents:ssllabs",
     Transform(
         valuespec = Dictionary(
            title = _("Check SSL Server via ssllabs API"),
            help = _("This rule selects the ssllabs agent, which fetches "
                 "SSL Certificate status from api.ssllabs.com. "),
            elements = [
                ( "sslhost",
                    TextAscii(
                    title = _("Server Name for ssl cert"),
                    allow_empty = False,
                    ),
                ),
                ( "timeout",
                    Integer(
                    title = _("Connect Timeout"),
                    help = _("The network timeout in seconds when communicating via HTTP. "
                             "The default is 180 seconds."),
                    default_value = 180,
                    minvalue = 1,
                    unit = _("seconds")
                    )
                ),
                ( "proxy",
                    TextAscii(
                    title = _("proxy server, if require"),
                    help = _("proxy in format: servername:port"),
                    ),
                ),
            ],
        ),
    ),
    factory_default = FACTORY_DEFAULT_UNUSED, # No default, do not use setting if no rule matches
    match = 'first')
