APT-NG - Check_MK Plugin to check for upgradeable Debian packages.

    It's based on plugin from Stefan Schlesinger https://github.com/sts/checkmk/tree/master/aptng.
    I change it to neu check_mk API and fix any thinks.

    Since 2.4, the check control if a reboot after kernel update required.
    (Depends on Debian Package apt-dater-host)  

    The script was tested on the following Debian versions: Lenny, Squeeze, Wheezy
    
// INSTALLATION INSTRUCTIONS

    On your Check_MK clients:
    
        Copy plugins/apt from mk package to your clients into /usr/lib/check_mk_agent/plugins/ or
        use the since check_mk version 1.2.3i1 available cache modus, into /usr/lib/check_mk_agent/plugins/14400/
        (for 4 hour check period)
    
    On your check Server:
    
        Install the apt-x.x.mk package.
