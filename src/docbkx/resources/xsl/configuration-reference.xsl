<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
>
  <xsl:output method="xml" indent="yes" cdata-section-elements="literallayout"/>

  <xsl:key name="unqiue-elms" match="//xs:element" use="@type" />

  <xsl:template match="/">
    <chapter version="5.0" xml:id="configuration-reference"
        xmlns="http://docbook.org/ns/docbook"
        xmlns:xlink="http://www.w3.org/1999/xlink">
      <title>Configuration reference</title>
      <subtitle>
        This section has been generated from the schema file 'spring-actionscript-objects-1.0.xsd'
      </subtitle>
      <sect1 xml:id="spring-actionscript-configuration">
        <title>General description</title>
        <xsl:apply-templates select="/xs:schema/xs:annotation/xs:documentation"/>
        <itemizedlist spacing="normal">
          <title>Overview</title>
          <xsl:for-each select="//xs:element[count(.|key('unqiue-elms',@type)[1]) = 1]">
            <xsl:sort select="@name"/>
            <listitem>
              <link linkend="anchor_{@type}">
                <xsl:value-of select="@name"/>
              </link>
            </listitem>
          </xsl:for-each>
        </itemizedlist>
        <xsl:for-each select="//xs:element[count(.|key('unqiue-elms',@type)[1]) = 1]">
          <xsl:sort select="@name"/>
          <xsl:variable name="tmp" select="@type"/>
          <xsl:variable name="tmp2" select="@name"/>
          <xsl:apply-templates select="//xs:complexType[@name=$tmp]">
            <xsl:with-param name="objName" select="$tmp2" />
          </xsl:apply-templates>
        </xsl:for-each>
      </sect1>
    </chapter>
  </xsl:template>

  <xsl:template match="xs:documentation">
    <literallayout>
      <xsl:value-of select="."/>
    </literallayout>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:complexType">
    <xsl:param name="objName" />
    <xsl:if test="xs:annotation/xs:documentation!=''">
      <section id="anchor_{@name}">
          <title>
            <programlisting>&lt;<xsl:value-of select="$objName"/>/&gt;</programlisting>
          </title>
          <xsl:apply-templates select="xs:annotation/xs:documentation"/>
        <xsl:if test="count(xs:attribute)&gt;0">
          <itemizedlist spacing="normal">
            <title>Attributes</title>
            <xsl:apply-templates select="xs:attribute"/>
          </itemizedlist>
        </xsl:if>
        <xsl:if test="count(xs:sequence)&gt;0">
          <para>
            The following elements occur in <xsl:value-of select="$objName"/>:
          </para>
          <simplelist type="inline">
            <xsl:apply-templates select="xs:sequence/xs:element"/>
          </simplelist>
        </xsl:if>
        <xsl:if test="count(xs:choice)&gt;0">
          <para>
            The following elements occur in <xsl:value-of select="$objName"/>:
          </para>
          <simplelist type="inline">
            <xsl:apply-templates select="xs:choice/xs:element"/>
          </simplelist>
        </xsl:if>
      </section>
      </xsl:if>
  </xsl:template>

  <xsl:template match="xs:element">
    <member>
      <link linkend="{@type}">
        <xsl:value-of select="@name"/>
      </link>
    </member>
  </xsl:template>

  <xsl:template match="xs:attribute">
    <listitem>
      <xsl:value-of select="@name"/>
      <xsl:if test="count(xs:simpleType/xs:restriction)&gt;0">
        =enumeration(<xsl:apply-templates select="xs:simpleType/xs:restriction/xs:enumeration">
          <xsl:sort select="@value"/>
        </xsl:apply-templates>)
      </xsl:if>
      <xsl:if test="@use='required'"> (required)</xsl:if>
      <remark>
        <xsl:apply-templates select="xs:annotation/xs:documentation"/>
      </remark>
    </listitem>
  </xsl:template>

  <xsl:template match="xs:enumeration">
    <xsl:if test="position()&gt;1">,</xsl:if><xsl:value-of select="@value"/>
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
