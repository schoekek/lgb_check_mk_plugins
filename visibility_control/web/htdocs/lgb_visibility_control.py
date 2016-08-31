#!/esr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

import sidebar, config, defaults, htmllib, views, table, userdb, weblib

def ajax_switch_visibility_control():

    state = True if int(html.var("state")) is 1 else False
    # check permissions
    if config.user_id and config.may('general.edit_profile'):
        #User DB auslesen
        users = userdb.load_users(lock=True)
        user = users.get(config.user_id)
        # Custom attributes
        if config.may('general.edit_user_attributes'):
            for name, attr in userdb.get_user_attributes():
                if attr['user_editable']:
                    if name == "force_authuser":
                        users[config.user_id][name] = state
                        userdb.save_users(users)
                        break

    auth_user_value = 1 if state is True else 0
    #render_visibility_control ??? der Aufruf geht hier leider nicht, findet anscheinend die Funktion nicht, deshalb hier doppelter Code ???
    html.write("<table class=visibility_control>\n")
    url = defaults.url_prefix + ("check_mk/switch_user_visibility.py?state=%d") % (1 - auth_user_value)
    onclick = "get_url('%s', updateContents, 'snapin_visibility_control'); parent.frames[1].location.reload();" % url
    html.write("<tr><td class=left>See only your own items</td><td>")
    html.icon_button("#", _("See only your own items %s") % (auth_user_value and "off" or "on"),
                     "snapin_switch_" + (auth_user_value and "on" or "off"), onclick=onclick)
    html.write("</td></tr>")
    html.write("</table>")
    html.set_browser_reload(1)
    html.reload_sidebar()

