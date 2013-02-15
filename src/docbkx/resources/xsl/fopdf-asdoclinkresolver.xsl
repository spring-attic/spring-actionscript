<?xml version="1.0" encoding="utf-8"?>
<!--     Spring Actionscript XSL to create links to asdoc API for html transformation-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0" exclude-result-prefixes="xsl fo xlink">

<xsl:import href="urn:docbkx:stylesheet"/>

<xsl:variable name="springasdoc" select="document('../../../../target/site/asdoc/toplevel.xml')/asdoc" />

<xsl:template match="//*[@xlink:href]">
    <xsl:if test="starts-with(@xlink:href, 'asdoc://')">
      <xsl:variable name="classpath" select="@xlink:href"/>
      <xsl:choose>
        <xsl:when test="contains($classpath,'#')">
          <xsl:variable name="asdocurl"  select="concat('../../../asdoc/', translate(substring-after($classpath,'asdoc://'), '.', '/'))"/>
          <xsl:variable name="asdocurl2">
            <xsl:call-template name="replace-substring">
              <xsl:with-param name="value" select="$asdocurl"/>
              <xsl:with-param name="from"><![CDATA[#]]></xsl:with-param>
              <xsl:with-param name="to"><![CDATA[.html#]]></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
			<fo:basic-link external-destination="{$asdocurl2}"
				xsl:use-attribute-sets="xref.properties" text-decoration="underline"
				color="blue">
				<xsl:choose>
					<xsl:when test="count(child::node())=0">
						<xsl:value-of select="node()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="asdocurl"  select="concat('../../../asdoc/', translate(substring-after($classpath,'asdoc://'), '.', '/'), '.html')"/>
			<fo:basic-link external-destination="{$asdocurl}"
				xsl:use-attribute-sets="xref.properties" text-decoration="underline"
				color="blue">
				<xsl:choose>
					<xsl:when test="count(child::node())=0">
						<xsl:value-of select="node()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
        </xsl:otherwise>
      </xsl:choose>
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

</xsl:stylesheet>


