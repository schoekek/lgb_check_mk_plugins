#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

def render_visibility_control():
    auth_user_value = 1 if config.user.get("force_authuser") is True else 0
    html.write("<table class=visibility_control>\n")
    url = defaults.url_prefix + ("check_mk/switch_user_visibility.py?state=%d") % (1 - auth_user_value)
    onclick = "get_url('%s', updateContents, 'snapin_visibility_control'); parent.frames[1].location.reload();" % url
    html.write("<tr><td class=left>See only your own items</td><td>")
    html.icon_button("#", _("See only your own items %s") % (auth_user_value and "off" or "on"),
                     "snapin_switch_" + (auth_user_value and "on" or "off"), onclick=onclick)
    html.write("</td></tr>")
    html.write("</table>")

sidebar_snapins["visibility_control"] = {
    "title" : _("Visibility control"),
    "description" : _("Buttons for switching the visibilty of Hosts/Services, display hosts and services that the user is a contact for - even if he has the permission for seeing all objects."),
    "render" : render_visibility_control,
    "allowed" : [ "admin", "user", ],
    "styles" : """
div.snapin table.visibility_control {
    width: 100%;
    margin: 0px 0px 0px 0px;
    border-spacing: 0px;
}

div.snapin table.visibility_control td {
    padding: 0px 0px;
    text-align: right;
}

div.snapin table.visibility_control td.left a {
    text-align: left;
    font-size: 8pt;
    font-weight: normal;
}

div.snapin table.visibility_control td.left {
    text-align: left;
}

div.snapin table.visibility_control td img.iconbutton {
    width: 60px;
    height: 16px;
}

"""
}
