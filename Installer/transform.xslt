<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"
    xmlns="http://schemas.microsoft.com/wix/2006/wi">

  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>
  <xsl:output method="xml" indent="yes" />

  <xsl:key name="file-search" match="wix:Component[contains(wix:File/@Source, 'unnecessary.xml')]" use="@Id"/>

  <!--
  Caution this filters all Files with pattern *myApp.exe* in it, so also "myApp.exe.config"
  <xsl:key name="config-search" match="wix:Component[contains(wix:File/@Source, 'myApp.exe')]" use="@Id"/>
  instead use
  -->
  <xsl:key name="config-search" match="wix:Component['myApp.exe' = substring(wix:File/@Source, string-length(wix:File/@Source) - string-length('myApp.exe') + 1)]" use="@Id"/>


  <xsl:template match="wix:Component[key('file-search', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('file-search', @Id)]" />

  <xsl:template match="wix:Component[key('config-search', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('config-search', @Id)]" />

  <xsl:template match="wix:File[contains(@Source, 'readonly.txt')]">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:attribute name="ReadOnly">yes</xsl:attribute>
      <xsl:apply-templates select="node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>