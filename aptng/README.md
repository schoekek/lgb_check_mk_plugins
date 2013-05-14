APT-NG - Check_MK Plugin to check for upgradeable Debian packages.

    It's based on plugin from Stefan Schlesinger https://github.com/sts/checkmk/tree/master/aptng.
    I change it to neu check_mk API and fix any thinks.

    Check upgradeable packages.

    The script was tested on the following Debian versions: Lenny, Squeeze, Wheezy
    
// INSTALLATION INSTRUCTIONS

    On your Check_MK clients:
    
        Copy plugins/apt from mk package to your clients into /usr/lib/check_mk_agent/plugins/apt
        Use the since check_mk version 1.2.2 vailible cache modus, into /usr/lib/check_mk_agent/plugins/14400/apt
        (for 4 hour check period)
    
    On your check Server:
    
        Install the apt-x.x.mk package.
