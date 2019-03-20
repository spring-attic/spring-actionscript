<?xml version="1.0" encoding="utf-8"?>
<!--     Spring Actionscript XSL to create links to asdoc API for html transformation-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:db="http://docbook.org/ns/docbook"
                version="1.0"
                exclude-result-prefixes="xsl fo xlink db">

  <xsl:variable name="springasdoc" select="document('../../../../target/site/asdoc/toplevel.xml')/asdoc" />

	<xsl:template match="//db:filename">
		<xsl:variable name="file-name" select="."/>
		<script language="javascript" type="text/javascript"><![CDATA[
<!--

// start the Viewer
if (!RunPlayer(
    "width", "100%",
    "height", "1200",]]>
    "graphUrl", "graphs/<xsl:value-of select="$file-name"/>",<![CDATA[
    "overview", "true",
    "toolbar", "true",
    "tooltips", "true",
    "movable", "true",
    "links", "true",
    "linksInNewWindow", "true",
    "viewport", "full"
    )) {
  // if RunPlayer() returns false: Flash Player is either too old or not installed
  // in this case: try to install a current flash player
  if (!InstallFlashUpdate("width", "100%", "height", "100%")) {
    // Flash Player is too old for the auto-update or not installed at all
    // Place alternative content here
    document.write('This content requires the Adobe Flash Player 9.0.38 or higher. '
        + '<a href=https://www.adobe.com/go/getflash/>Get Flash</a>');
  }
}
-->]]>
</script>
	</xsl:template>

  <xsl:template match="//db:literal[count(@linkend)=0 and count(@xlink:href)=0]">
    <xsl:variable name="class-name" select="."/>
    <xsl:variable name="classtest" select="$springasdoc/classRec[@name=$class-name]/@fullname"/>
    <xsl:variable name="intftest" select="$springasdoc/interfaceRec[@name=$class-name]/@fullname"/>
    <xsl:choose>
      <xsl:when test="$classtest">
        <xsl:call-template name="getAsdocURL">
          <xsl:with-param name="class-path" select="$classtest"/>
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="description" select="$springasdoc/classRec[@name=$class-name]/description"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$intftest">
        <xsl:call-template name="getAsdocURL">
          <xsl:with-param name="class-path" select="$intftest"/>
          <xsl:with-param name="class-name" select="$class-name"/>
          <xsl:with-param name="description" select="$springasdoc/interfaceRec[@name=$class-name]/description"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//*[@xlink:href!='']">
    <xsl:if test="starts-with(@xlink:href, 'dtd://')">
      <xsl:variable name="dtdpath" select="@xlink:href"/>
      <xsl:variable name="dtdurl"  select="concat('configuration-reference.html#', translate(substring-after($dtdpath,'dtd://'), '.', '/'))"/>
      <a class="dtdclass" href="{$dtdurl}" target="_blank">
        <xsl:apply-templates />
      </a>
    </xsl:if>
    <xsl:if test="starts-with(@xlink:href, 'local://')">
      <xsl:variable name="localurl" select="@xlink:href"/>
      <a class="httpclass" href="{substring-after($localurl,'local://')}" title="{@xlink:title}" target="_blank">
        <xsl:apply-templates />
      </a>
    </xsl:if>
    <xsl:if test="starts-with(@xlink:href, 'http')">
      <xsl:variable name="httpurl" select="@xlink:href"/>
      <a class="httpclass" href="{$httpurl}" target="_blank" title="{@xlink:title}">
        <xsl:apply-templates />
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template name="replace-substring">
    <xsl:param name="value"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:choose>
      <xsl:when test="contains($value,$from)">
        <xsl:value-of select="substring-before($value,$from)"/>
        <xsl:value-of select="$to"/>
        <xsl:call-template name="replace-substring">
          <xsl:with-param name="value" select="substring-after($value,$from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getAsdocURL">
    <xsl:param name="class-path"/>
    <xsl:param name="class-name"/>
    <xsl:param name="description"/>
    <xsl:variable name="replaced">
      <xsl:call-template name="replace-substring">
        <xsl:with-param name="value" select="$class-path"/>
        <xsl:with-param name="from"><![CDATA[.]]></xsl:with-param>
        <xsl:with-param name="to"><![CDATA[/]]></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="asdocurlsuffix">
      <xsl:call-template name="replace-substring">
        <xsl:with-param name="value" select="$replaced"/>
        <xsl:with-param name="from"><![CDATA[:]]></xsl:with-param>
        <xsl:with-param name="to"><![CDATA[/]]></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="asdocurl"  select="concat('../../../asdoc/', $asdocurlsuffix)"/>
    <a class="asclass" href="{$asdocurl}.html" target="_blank">
      <xsl:value-of select="$class-name"/>
      <xsl:if test="$description">
        <span class="toolTipContent">
          <xsl:value-of select="$description" disable-output-escaping="yes" />
        </span>
      </xsl:if>
    </a>
  </xsl:template>

  <xsl:template name="getClassDetailDescription">
    <xsl:param name="classpath"/>
    <xsl:variable name="detail" select="substring-after($classpath,'#')"/>
    <xsl:choose>
      <xsl:when test="contains($detail,'(')">
        <xsl:variable name="methodname" select="translate($detail,'()','')"/>
        <xsl:variable name="nodetest" select="$springasdoc//method[@name=$methodname]/shortDescription"/>
        <xsl:if test="$nodetest">
          <span class="toolTipContent">
            <xsl:value-of select="$nodetest" disable-output-escaping="yes" />
          </span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="nodetest2" select="$springasdoc//field[@name=$detail]/shortDescription"/>
        <xsl:if test="$nodetest2">
          <span class="toolTipContent">
            <xsl:value-of select="$nodetest2" disable-output-escaping="yes" />
          </span>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getClassDescription">
    <xsl:param name="classpath"/>
    <xsl:variable name="fullname">
      <xsl:call-template name="makeFullName">
        <xsl:with-param name="str" select="$classpath"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="nodetest" select="$springasdoc//asClass[@fullname=$fullname]/shortDescription"/>
    <xsl:if test="$nodetest">
      <span class="toolTipContent">
        <xsl:value-of select="$nodetest" disable-output-escaping="yes" />
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="makeFullName">
    <xsl:param name="str" select="."/>
    <xsl:param name="splitString" select="'.'"/>
    <xsl:param name="firstRun" select="'true'"/>
    <xsl:choose>
      <xsl:when test="contains($str,$splitString)">
        <xsl:variable name="after" select="substring-after($str,$splitString)"/>
        <xsl:choose>
          <xsl:when test="$after!=''">
            <xsl:if test="$firstRun!='true'">
              <xsl:text>.</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>:</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="substring-before($str,$splitString)"/>
        <xsl:call-template name="makeFullName">
          <xsl:with-param name="str"
    select="substring-after($str,$splitString)"/>
          <xsl:with-param name="splitString" select="$splitString"/>
          <xsl:with-param name="firstRun" select="'false'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>:</xsl:text><xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
