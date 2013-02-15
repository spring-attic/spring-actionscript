<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" cdata-section-elements="description author example docref see param return externalref"/>

  <xsl:param name="baseDir" select="'C:/resources/flex/SpringAS-WRITEACCESS/trunk'"/>

  <xsl:template match="/">
    <asdoc>
      <xsl:apply-templates select="files/toplevels/file"/>
    </asdoc>
  </xsl:template>

  <xsl:template match="file">
    <xsl:apply-templates select="document(concat($baseDir,'/',@moduleName,.))/asdoc">
      <xsl:with-param name="moduleName" select="@moduleName"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="files/toplevel_classes/file"/>

  <xsl:template match="/asdoc">
    <xsl:param name="moduleName"/>
    <xsl:apply-templates select="interfaceRec|classRec">
      <xsl:with-param name="moduleName" select="$moduleName"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="interfaceRec|classRec">
    <xsl:param name="moduleName"/>
    <xsl:copy>
      <xsl:attribute name="moduleName">
        <xsl:value-of select="$moduleName"/>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()" mode="deep"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="deep">
    <xsl:copy >
      <xsl:apply-templates select="@* | node()" mode="deep"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
