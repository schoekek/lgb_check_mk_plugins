APT-NG - Check_MK Plugin to check for upgradeable Debian packages.

    It's based on plugin from Stefan Schlesinger https://github.com/sts/checkmk/tree/master/aptng.
    I change it to new check_mk API and fix any thinks.

    Since 2.5, the check control if a reboot after kernel update required.

    The script was tested on the following Debian versions: Lenny, Squeeze, Wheezy, Jessie, Stretch
    
INSTALLATION INSTRUCTIONS

    On your Check_MK clients:
    
        Copy plugins/apt from mk package to your clients into /usr/lib/check_mk_agent/plugins/ or
        use the since check_mk version 1.2.3i1 available cache modus, into /usr/lib/check_mk_agent/plugins/14400/
        (for 4 hour check period)
    
    On your check Server:
    
        Install the apt-x.x.mk package.

AGENT DEPLOYING AND PACKAGING

    We package the agent and helpful thinks into debian packages.
    Following is integrated:
    - the agent Plugin ;-)
    - a script to remove the agent plugin cache under /usr/sbin/lgb-check-mk-agent-aptng
    - a kernel post script to remove the agent plugin cache after a neu kernel installation
      under /etc/kernel/postinst.d/lgb-check-mk-agent-aptng-reboot
    - a dpkg post install script to remove the agent plugin cache after a neu package installation
      under /etc/apt/apt.conf.d/99lgb-check-mk-agent-aptng
    - a rc.local entry to remove the agent plugin cache after a reboot
      --> via puppet ;-)
