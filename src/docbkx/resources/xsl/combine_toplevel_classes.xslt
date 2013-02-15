<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" cdata-section-elements="versions description shortDescription author example docref see param return externalref sampleref"/>

  <xsl:param name="baseDir" select="'../../../../'"/>

  <xsl:template match="/">
    <asdoc>
      <link rel="stylesheet" href="style.css" type="text/css"/>
      <packages>
        <xsl:apply-templates select="files/toplevel_classes/file"/>
      </packages>
    </asdoc>
  </xsl:template>

  <xsl:template match="files/toplevels/file"/>

  <xsl:template match="file">
    <xsl:apply-templates select="document(concat($baseDir,'/',@moduleName,.))/asdoc/packages">
      <xsl:with-param name="moduleName" select="@moduleName"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="packages">
    <xsl:param name="moduleName"/>
    <xsl:apply-templates select="asPackage">
      <xsl:with-param name="moduleName" select="$moduleName"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="asPackage">
    <xsl:param name="moduleName"/>
    <xsl:copy>
      <xsl:attribute name="moduleName">
        <xsl:value-of select="$moduleName"/>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()" mode="deep"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="deep">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="deep"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
