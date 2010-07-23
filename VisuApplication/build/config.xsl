<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output 
		method="xml"
		encoding="utf-8"
		indent="yes" 
		/>

		<xsl:template match="flexLibProperties">
			<flex-config>
				<xsl:apply-templates select="//resourceEntry" />
			</flex-config>
		</xsl:template>

		<xsl:template match="resourceEntry">
			<include-file>
				<name><xsl:value-of select="@destPath" /></name>
				<path><xsl:value-of select="@sourcePath" /></path>
			</include-file>
		</xsl:template>

	</xsl:stylesheet>