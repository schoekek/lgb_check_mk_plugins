<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match="/">
    <xsl:comment>Count variable values</xsl:comment>
    <xsl:variable name="hoststot" select="count(/nagstatus/host)" />
    <xsl:variable name="hostsok" select="count(/nagstatus/host[current_state=0])" />
    <xsl:variable name="hostsdown" select="count(/nagstatus/host[current_state=1 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])" />
    <xsl:variable name="hostsunreach" select="count(/nagstatus/host[current_state=2 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])" />
    <xsl:variable name="hostsack" select="count(/nagstatus/host[current_state&gt;0 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" />
    
    <xsl:variable name="servtot" select="count(/nagstatus/host/service)" />
    <xsl:variable name="servok" select="count(/nagstatus/host/service[current_state=0])" />
    <xsl:variable name="servwarn" select="count(/nagstatus/host/service[current_state=1 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])" />
    <xsl:variable name="servcrit" select="count(/nagstatus/host/service[current_state=2 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])" />
    <xsl:variable name="servunk" select="count(/nagstatus/host/service[current_state=3 and problem_has_been_acknowledged=0 and scheduled_downtime_depth=0])" />
    <xsl:variable name="servack" select="count(/nagstatus/host/service[current_state&gt;0 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" />

    <xsl:variable name="per_hostsok" select="round($hostsok div $hoststot * 100)" />
    <xsl:variable name="per_hostsdown" select="round($hostsdown div $hoststot * 100)" />
    <xsl:variable name="per_hostsunreach" select="round($hostsunreach div $hoststot * 100)" />
    <xsl:variable name="per_hostsack" select="round($hostsack div $hoststot * 100)" />

    <xsl:variable name="per_servok" select="round($servok div $servtot * 100)" />
    <xsl:variable name="per_servwarn" select="round($servwarn div $servtot * 100)" />
    <xsl:variable name="per_servcrit" select="round($servcrit div $servtot * 100)" />
    <xsl:variable name="per_servunk" select="round($servunk div $servtot * 100)" />
    <xsl:variable name="per_servack" select="round($servack div $servtot * 100)" />

    <div id="windowtitlearea" style="position:absolute;width:100px;height:10px;top:7px;left:14px;font-weight:bold;text-align:left;"></div>
    <div id="hosttitle" style="position:absolute;width:50px;height:10px;top:22px;left:14px;style:bold;">
        Hosts<script type="text/javascript">document.write("asdf");</script>
    </div>
    
    <img id="hostback" src="images/barback.png" style="position:absolute;top:36px;left:14px;width=100px;height=6px;" />
    <div id="hostbar" style="position:absolute;overflow:hidden;width:100px;height:6px;top:36px;left:14px;">
        <xsl:if test="$hostsok&gt;0">
            <img id="hostokbar" src="images/bargreen.png"
                 style="width:{$per_hostsok}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$hostsack&gt;0">
            <img id="hostsackbar" src="images/barblue.png"
                 style="width:{$per_hostsack}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$hostsunreach&gt;0">
            <img id="hostsunreachbar" src="images/barorange.png"
                 style="width:{$per_hostsunreach}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$hostsdown&gt;0">
            <img id="hostsdownbar" src="images/barred.png"
                 style="width:{$per_hostsdown}px;height:6px;" />
        </xsl:if>
    </div>
    <!--
    <div id="hostok" style="position:absolute;overflow:hidden;width:18px;height:24px;top:44px;left:12px;text-align:center;">
        <xsl:choose>
            <xsl:when test="$hostsok=0">
                <span style="color:red;">OK<br /><xsl:value-of select="$hostsok" /></span>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:green;">OK<br /><xsl:value-of select="$hostsok" /></span>
            </xsl:otherwise>
        </xsl:choose>
    </div>
    -->
    <div id="hostunreach" style="position:absolute;overflow:hidden;width:58px;height:24px;top:44px;left:12px;text-align:center;">
        <xsl:choose>
            <xsl:when test="count(/nagstatus/host[current_state=2])=0">
                <span style="color:gray;">Unreachable<br />0</span>
            </xsl:when>
            <xsl:when test="$hostsunreach&gt;0">
                <span style="color:orange">Unreachable<br /><xsl:value-of select="$hostsunreach" /></span>
                <xsl:if test="count(/nagstatus/host[current_state=2 and problem_has_been_acknowledged&gt;0])&gt;0">
                    <span style="color:grey;"> / </span><span style="color:blue;">
                    <xsl:value-of select="count(/nagstatus/host[current_state=2 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:blue;">Unreachable<br /><xsl:value-of select="count(/nagstatus/host[current_state=2 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
            </xsl:otherwise>
        </xsl:choose>
    </div>
    
    <div id="hostdown" style="position:absolute;overflow:hidden;width:48px;height:24px;top:44px;left:71px;text-align:center;">
        <xsl:choose>
            <xsl:when test="count(/nagstatus/host[current_state=1])=0">
                <span style="color:gray;">Down<br />0</span>
            </xsl:when>
            <xsl:when test="$hostsdown&gt;0">
                <span style="color:red">Down<br /><xsl:value-of select="$hostsdown" /></span>
                <xsl:if test="count(/nagstatus/host[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])&gt;0">
                    <span style="color:grey;"> / </span><span style="color:blue;">
                    <xsl:value-of select="count(/nagstatus/host[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:blue;">Down<br /><xsl:value-of select="count(/nagstatus/host[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
            </xsl:otherwise>
        </xsl:choose>
    </div>
    
    <div id="servtitle" style="position:absolute;width:100px;height:10px;top:72px;left:14px;">
        Services
    </div>

    <img id="servback" src="images/barback.png" style="position:absolute;top:86px;left:14px;width=100px;height=6px;" />
    <div id="servbar" style="position:absolute;overflow:hidden;width:100px;height:6px;top:86px;left:14px;">
        <xsl:if test="$servok&gt;0">
            <img id="servokbar" src="images/bargreen.png"
                 style="width:{$per_servok}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$servack&gt;0">
            <img id="servackbar" src="images/barblue.png"
                 style="width:{$per_servack}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$servwarn&gt;0">
            <img id="servwarnbar" src="images/barorange.png"
                 style="width:{$per_servwarn}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$servcrit&gt;0">
            <img id="servcritbar" src="images/barred.png"
                 style="width:{$per_servcrit}px;height:6px;" />
        </xsl:if>
        <xsl:if test="$servunk&gt;0">
            <img id="servunkbar" src="images/baryellow.png"
                 style="width:{$per_servunk}px;height:6px;" />
        </xsl:if>
    </div>
    <!--
    <div id="servok" style="position:absolute;overflow:hidden;width:18px;height:24px;top:94px;left:12px;text-align:center;">
        <xsl:choose>
            <xsl:when test="$servok=0">
                <span style="color:red;">OK<br /><xsl:value-of select="$servok" /></span>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:green;">OK<br /><xsl:value-of select="$servok" /></span>
            </xsl:otherwise>
        </xsl:choose>
    </div>
    -->
    <div id="servwarn" style="position:absolute;overflow:hidden;width:35px;height:24px;top:94px;left:12px;text-align:center;">
        <xsl:choose>
            <xsl:when test="count(/nagstatus/host/service[current_state=1])=0">
                <span style="color:gray;">Warn<br />0</span>
            </xsl:when>
            <xsl:when test="$servwarn&gt;0">
                <span style="color:orange;">Warn<br /><xsl:value-of select="$servwarn" /></span>
                <xsl:if test="count(/nagstatus/host/service[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])&gt;0">
                    <span style="color:gray;"> / </span><span style="color:blue;">
                    <xsl:value-of select="count(/nagstatus/host/service[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:blue;">Warn<br /><xsl:value-of select="count(/nagstatus/host/service[current_state=1 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
            </xsl:otherwise>
        </xsl:choose>
        <br />
    </div>
    
    <div id="servcrit" style="position:absolute;overflow:hidden;width:35px;height:24px;top:94px;left:47px;text-align:center;">
        <xsl:choose>
            <xsl:when test="count(/nagstatus/host/service[current_state=2])=0">
                <span style="color:gray;">Crit<br />0</span>
            </xsl:when>
            <xsl:when test="$servcrit&gt;0">
                <span style="color:red;">Crit<br /><xsl:value-of select="$servcrit" /></span>
                <xsl:if test="count(/nagstatus/host/service[current_state=2 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])&gt;0">
                    <span style="color:gray;"> / </span><span style="color:blue;">
                    <xsl:value-of select="count(/nagstatus/host/service[current_state=2 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:blue;">Crit<br /><xsl:value-of select="count(/nagstatus/host/service[current_state=2 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
            </xsl:otherwise>
        </xsl:choose>
        <br />
    </div>
    
    <div id="servunk" style="position:absolute;overflow:hidden;width:35px;height:24px;top:94px;left:82px;text-align:center;">
        <xsl:choose>
            <xsl:when test="count(/nagstatus/host/service[current_state=3])=0">
                <span style="color:gray;">Unkn<br />0</span>
            </xsl:when>
            <xsl:when test="$servunk&gt;0">
                <span style="color:yellow;">Unkn<br /><xsl:value-of select="$servcrit" /></span>
                <xsl:if test="count(/nagstatus/host/service[current_state=3 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])&gt;0">
                    <span style="color:gray;"> / </span><span style="color:blue;">
                    <xsl:value-of select="count(/nagstatus/host/service[current_state=3 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:blue;">Unkn<br /><xsl:value-of select="count(/nagstatus/host/service[current_state=3 and not(problem_has_been_acknowledged=0 and scheduled_downtime_depth=0)])" /></span>
            </xsl:otherwise>
        </xsl:choose>
    </div>
    
</xsl:template>

</xsl:stylesheet>