<?xml version="1.0" encoding="utf-8"?>

<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2006-2007 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="exslt date str"
	xmlns:str="http://exslt.org/strings"
	xmlns:exslt="http://exslt.org/common" >

  <!-- <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="UTF-8" indent="yes"/> -->
  <xsl:output method="html" encoding="UTF-8" indent="yes" />

  <xsl:template match="customs">
    <xsl:param name="packageName"/>
    <xsl:param name="moduleName"/>
    <xsl:variable name="baseRef">
      <xsl:text>../</xsl:text>
      <xsl:call-template name="getBaseRef">
        <xsl:with-param name="packageName" select="$packageName"/>
      </xsl:call-template>
    </xsl:variable>
    <div class="MainContent">
      <xsl:apply-templates select="docref">
        <xsl:with-param name="baseRef" select="$baseRef"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="sampleref">
        <xsl:with-param name="moduleName" select="$moduleName"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="externalref"/>
      <hr />
    </div>
  </xsl:template>

  <xsl:template match="docref">
    <xsl:param name="baseRef"/>
    <p>
      <span class="classHeaderTableLabel">
        <xsl:text>Documentation reference: </xsl:text>
      </span>
      <xsl:variable name="docref">
        <xsl:value-of select="translate(.,$newline,'')" disable-output-escaping="yes"/>
      </xsl:variable>
      <a href="{$baseRef}docs/reference/html/{$docref}" target="_blank"><xsl:call-template name="formatDocRefCaption"><xsl:with-param name="docref" select="$docref"/></xsl:call-template></a>
    </p>
  </xsl:template>

  <xsl:template match="sampleref">
    <xsl:param name="moduleName"/>
    <p>
      <span class="classHeaderTableLabel" title="Links to a compiled sample project demonstrating the use of this class">
        <xsl:text>Sample project: </xsl:text>
      </span>
      <xsl:variable name="samplerefurl">
      	<xsl:call-template name="makeSampleURL">
          <xsl:with-param name="name">
        	  <xsl:value-of select="translate(.,$newline,'')" disable-output-escaping="yes"/>
          </xsl:with-param>
          <xsl:with-param name="moduleName" select="$moduleName"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="samplesourceurl">
      	<xsl:call-template name="makeSampleSourceURL">
          <xsl:with-param name="name">
        	  <xsl:value-of select="translate(.,$newline,'')" disable-output-escaping="yes"/>
          </xsl:with-param>
          <xsl:with-param name="moduleName" select="$moduleName"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="{$samplerefurl}" target="_blank"><xsl:value-of select="."/></a> (<a href="{$samplesourceurl}" target="_blank">source</a>)
    </p>
  </xsl:template>

  <xsl:template match="externalref">
    <p>
      <span class="classHeaderTableLabel">
        <xsl:text>External reference: </xsl:text>
      </span>
      <a href="{.}" target="_blank">
        <xsl:value-of select="." />
      </a>
    </p>
  </xsl:template>

  <xsl:template name="svnBrowseLink">
    <xsl:param name="packageName"/>
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:variable name="urlpath">
      <xsl:call-template name="makeSVNBrowseURL">
        <xsl:with-param name="packageName" select="$packageName"/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="moduleName" select="$moduleName"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="{$urlpath}" target="_blank">
      <xsl:value-of select="$name"/>
      <xsl:text>.as</xsl:text>
    </a>
  </xsl:template>

  <xsl:template name="fisheyeLink">
    <xsl:param name="packageName"/>
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:variable name="urlpath">
      <xsl:call-template name="makeFishEyeURL">
        <xsl:with-param name="packageName" select="$packageName"/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="moduleName" select="$moduleName"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="{$urlpath}" target="_blank">
      <xsl:value-of select="$name"/>
      <xsl:text>.as</xsl:text>
    </a>
  </xsl:template>

  <xsl:template name="addIcons">
    <xsl:param name="packageName"/>
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:variable name="svnurlpath">
      <xsl:call-template name="makeSVNBrowseURL">
        <xsl:with-param name="packageName" select="$packageName"/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="moduleName" select="$moduleName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="fisheyeurlpath">
      <xsl:call-template name="makeFishEyeURL">
        <xsl:with-param name="packageName" select="$packageName"/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="moduleName" select="$moduleName"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="{$svnurlpath}" target="_blank" title="Direct link to the online SVN browser">
      <img width="16" height="16" src="images/subversion_logo_notxt-16m.png"/>
    </a>
    <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
    <a href="{$fisheyeurlpath}" target="_blank" title="Direct link to the online Fisheye viewer">
      <img width="16" height="16" src="images/fisheye_header_logo.png"/>
    </a>
  </xsl:template>

  <xsl:template name="makeFishEyeURL">
    <xsl:param name="packageName"/>
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:text>https://fisheye.springsource.org/browse/se-springactionscript-as/trunk/</xsl:text><xsl:value-of select="$moduleName"/><xsl:text>/src/main/actionscript/</xsl:text>
    <xsl:value-of select="translate($packageName,'.','/')"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>.as</xsl:text>
  </xsl:template>

  <xsl:template name="makeSVNBrowseURL">
    <xsl:param name="packageName"/>
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:text>https://src.springframework.org/svn/se-springactionscript-as/trunk/</xsl:text><xsl:value-of select="$moduleName"/><xsl:text>/src/main/actionscript/</xsl:text>
    <xsl:value-of select="translate($packageName,'.','/')"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>.as</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeSampleURL">
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:text>/test-apps/</xsl:text>
    <xsl:value-of select="translate($name,' ','')" disable-output-escaping="yes"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="translate($name,' ','')" disable-output-escaping="yes"/>
    <xsl:text>.swf</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeSampleSourceURL">
    <xsl:param name="name"/>
    <xsl:param name="moduleName"/>
    <xsl:text>/test-apps/</xsl:text>
    <xsl:value-of select="translate($name,' ','')" disable-output-escaping="yes"/>
    <xsl:text>/srcview/index.html</xsl:text>
  </xsl:template>

  <xsl:template name="formatDocRefCaption">
    <xsl:param name="docref"/>
    <xsl:choose>
      <xsl:when test="contains($docref,'#')">
      	<xsl:value-of select="translate(substring-after($docref,'#'),'_',' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate(substring-before($docref,'.html'),'_',' ')"/>
      </xsl:otherwise>
    </xsl:choose>
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