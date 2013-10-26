<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:nagstatus="http://markkanen.net/nagstatusnamespace" >

<msxsl:script language="javascript" implements-prefix="nagstatus">
    function zeroPad(number, digits) {
        number = number.toString();
        while (number.length &lt; digits) {
            number = '0' + number;
        }
        return number;
    }
    function timestampToString(javaTimestamp) {
        var dateObj = new Date(javaTimestamp);
        var strDate = dateObj.getFullYear().toString() + "-" +
                      zeroPad((dateObj.getMonth() + 1), 2) + "-" +
                      zeroPad(dateObj.getDate(), 2) + " " +
                      zeroPad(dateObj.getHours(), 2) + ":" +
                      zeroPad(dateObj.getMinutes(), 2) + ":" +
                      zeroPad(dateObj.getSeconds(), 2);
        return strDate;
    }
</msxsl:script>

<xsl:template match="/nagstatus">

    <div id="heading" style="position:absolute;height:40px;width:100px;top:10px;left:14px;color:white;font-weight:bold;">
        <a href="#" onClick="openNagiosUrl();" style="color:white;">Nagios Status</a>
    </div>

    <div id="totals" style="position:absolute;height:40px;width:180px;top:10px;left:120px;color:white;font-size:x-small;">
        # of hosts: <xsl:value-of select="count(host)" /><br />
        # of services: <xsl:value-of select="count(host/service)" />
    </div>

    <div id="stats" style="position:absolute;height:40px;width:220px;top:10px;left:300px;color:white;font-size:x-small;">
        Nagios up since: <xsl:value-of select="nagstatus:timestampToString(program/program_start*1000)" /><br />
        Last command check: <xsl:value-of select="nagstatus:timestampToString(program/last_command_check*1000)" /><br />
        Last state change: <xsl:value-of select="nagstatus:timestampToString(program/last_state_change*1000)" />
    </div>

    <div id="problist" style="position:absolute;overflow:auto;height:340px;width:285px;top:55px;left:14px;color:white;font-size:xx-small;">
        <b>Hosts and Services with Unacknowledged Problems</b><br />
        <xsl:comment>Unreachable hosts that have not been acknowledged nor scheduled</xsl:comment>
        <xsl:apply-templates select="host[current_state=2 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0]" />
        <xsl:comment>Down hosts that have not been acknowledged nor scheduled</xsl:comment>
        <xsl:apply-templates select="host[current_state=1 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0]" />
        <!-- <xsl:comment>Unreachable/down hosts that have been acknowledged or scheduled, but have non-acknowledged/scheduled failed services</xsl:comment>
        <xsl:apply-templates select="host[current_state&gt;0 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0) and count(service[current_state&gt;0 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])&gt;0]" />-->
        <xsl:comment>OK hosts that have not been acknowledged nor scheduled and have non-acknowledged/scheduled failed services</xsl:comment>
        <xsl:apply-templates select="host[current_state=0 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0 and count(service[current_state&gt;0 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])&gt;0]" />
    </div>

    <div id="oklist" style="position:absolute;overflow:auto;height:340px;width:285px;top:55px;left:313px;color:white;font-size:xx-small;">
        <b>Hosts and Services OK/Problems Acknowledged</b><br />
        <xsl:comment>Unreachable/down hosts that have been acknowledged, and have not non-acknowledged/scheduled failed services</xsl:comment>
        <xsl:apply-templates select="host[current_state&gt;0 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0) and count(service[current_state&gt;0 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])=0]" />
        <xsl:comment>OK hosts that have acknowledged/scheduled failed services, but no non-acknowledged/sheduled ones</xsl:comment>
        <xsl:apply-templates select="host[current_state=0 and count(service[current_state&gt;0 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])=0 and count(service[current_state&gt;0])&gt;0]" />
        <xsl:comment>OK hosts that no failed services</xsl:comment>
        <xsl:apply-templates select="host[current_state=0 and count(service[current_state&gt;0])=0]" />
    </div>

</xsl:template>

<xsl:template match="host">
    <xsl:variable name="host" select="@name" />
    <xsl:choose>
        <xsl:when test="current_state=0">
            <img src="images/trafficlight_green_10x10.jpg" style="padding-top:7px;padding-right:5px;vertical-align:bottom;" />
        </xsl:when>
        <xsl:when test="current_state=1">
            <img src="images/trafficlight_red_10x10.jpg" style="padding-top:7px;padding-right:5px;vertical-align:bottom;" />
        </xsl:when>
        <xsl:otherwise>
            <img src="images/trafficlight_yellow_10x10.jpg" style="padding-top:7px;padding-right:5px;vertical-align:bottom;" />
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="problem_has_been_acknowledged&gt;0"><span style="color:white;vertical-align:bottom;">[ACK] </span></xsl:if>
    <xsl:if test="scheduled_downtime_depth&gt;0"><span style="color:white;vertical-align:bottom;">[SCHED] </span></xsl:if>
    <a href="#" onClick="openNagiosExtinfo('{$host}','');" style="color:white;vertical-align:bottom;font-weight:bold;"><xsl:value-of select="@name" /></a><br />
    <xsl:if test="current_state&gt;0">
        <div style="margin-left:14px;"><xsl:value-of select="plugin_output" /><br />
        Last change: <xsl:value-of select="nagstatus:timestampToString(last_state_change*1000)" />
        </div>
    </xsl:if>
    <xsl:apply-templates select="service[current_state=2]" />
    <xsl:apply-templates select="service[current_state=1]" />
    <xsl:apply-templates select="service[current_state=3]" />
    <xsl:apply-templates select="service[current_state=0]" />
</xsl:template>

<xsl:template match="service">
    <xsl:variable name="host" select="@host" />
    <xsl:variable name="service" select="@description" />
    <xsl:choose>
        <!--<xsl:when test="current_state=0">
            <img style="padding:2px;padding-left:14px;padding-right:5px;vertical-align:middle;" src="images/trafficlight_green_10x10.jpg" />
        </xsl:when>-->
        <xsl:when test="current_state=2">
            <img style="padding:2px;padding-left:14px;padding-right:5px;vertical-align:middle;" src="images/trafficlight_red_10x10.jpg" />
        </xsl:when>
        <xsl:when test="current_state=1">
            <img style="padding:2px;padding-left:14px;padding-right:5px;vertical-align:middle;" src="images/trafficlight_orange_10x10.jpg" />
        </xsl:when>
		       <xsl:when test="current_state=3">
            <img style="padding:2px;padding-left:14px;padding-right:5px;vertical-align:middle;" src="images/trafficlight_yellow_10x10.jpg" />
        </xsl:when>
    </xsl:choose>
    <xsl:if test="problem_has_been_acknowledged&gt;0">[ACK] </xsl:if>
    <xsl:if test="scheduled_downtime_depth&gt;0">[SCHED] </xsl:if>
    <!-- nur nicht ok services auflisten-->
	<xsl:if test='current_state&gt;0'>
        <a href="#" onClick="openNagiosExtinfo('{$host}','{$service}')" style="color:white;"><xsl:value-of select="@description" /></a><br />
    <!--<xsl:if test="current_state&gt;0">-->
        <div style="margin-left:28px;"><xsl:value-of select="plugin_output" /><br />
        Last change: <xsl:value-of select="nagstatus:timestampToString(last_state_change*1000)" />
        </div>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>