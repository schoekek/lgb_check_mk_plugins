xmpp - Check_MK Plugin to use fexible notification whith xmpp.

Any feedback welcome, PM to karsten.schoeke[at]geobasis-bb[dot]de. I'm also reading the german
check_mk ML: checkmk-de@lists.mathias-kettner.de
    
// INSTALLATION INSTRUCTIONS

On your check Server:
    
    Install the xmpp-x.x.mk package.
	
	Praparate your multisite user management, to use a 'Custom Attribut' named 'IM' and this as a Custom Macro.

	Insert the variable in your nagios/icinga check_mk template file.
```
	command_name check-mk-notify
  		command_line \
       		NOTIFY_CONTACTIM='$_CONTACTIM$' \
	 	check_mk --notify
	}
```
