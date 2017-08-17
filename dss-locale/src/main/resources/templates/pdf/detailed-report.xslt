<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:dss="http://dss.esig.europa.eu/validation/detailed-report">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/dss:DetailedReport">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master>
					<xsl:attribute name="master-name">A4-portrait</xsl:attribute>
					<xsl:attribute name="page-height">29.7cm</xsl:attribute>
					<xsl:attribute name="page-width">21cm</xsl:attribute>
					<xsl:attribute name="margin-top">1cm</xsl:attribute>
					<xsl:attribute name="margin-bottom">1cm</xsl:attribute>
					<xsl:attribute name="margin-right">2.5cm</xsl:attribute>
					<xsl:attribute name="margin-left">2.5cm</xsl:attribute>
			
					<fo:region-body>
						<xsl:attribute name="margin-top">1cm</xsl:attribute>
						<xsl:attribute name="margin-bottom">2cm</xsl:attribute>
					</fo:region-body>

					<fo:region-after>
						<xsl:attribute name="region-name">page-footer</xsl:attribute>
						<xsl:attribute name="extent">1.5cm</xsl:attribute>
					</fo:region-after>
			
				</fo:simple-page-master>
			</fo:layout-master-set>

<!-- 			<fo:bookmark-tree> -->
<!-- 				<fo:bookmark> -->
<!-- 					<xsl:attribute name="internal-destination">basicBuildingBlocks</xsl:attribute> -->
<!-- 					<fo:bookmark-title>Basic Building Blocks</fo:bookmark-title> -->
<!-- 				</fo:bookmark> -->
<!-- 				<fo:bookmark> -->
<!-- 					<xsl:attribute name="internal-destination">basicValidationData</xsl:attribute> -->
<!-- 					<fo:bookmark-title>Basic Validation Data</fo:bookmark-title> -->
<!-- 				</fo:bookmark> -->
<!-- 				<fo:bookmark> -->
<!-- 					<xsl:attribute name="internal-destination">timestampValidationData</xsl:attribute> -->
<!-- 					<fo:bookmark-title>Timestamp Validation Data</fo:bookmark-title> -->
<!-- 				</fo:bookmark> -->
<!-- 				<fo:bookmark> -->
<!-- 					<xsl:attribute name="internal-destination">adestValidationData</xsl:attribute> -->
<!-- 					<fo:bookmark-title>AdES-T Validation Data</fo:bookmark-title> -->
<!-- 				</fo:bookmark> -->
<!-- 				<fo:bookmark> -->
<!-- 					<xsl:attribute name="internal-destination">longTermValidationData</xsl:attribute> -->
<!-- 					<fo:bookmark-title>Long Term Validation Data</fo:bookmark-title> -->
<!-- 				</fo:bookmark> -->
								
<!-- 			</fo:bookmark-tree> -->

			<fo:page-sequence>
				<xsl:attribute name="master-reference">A4-portrait</xsl:attribute>
	
				<fo:static-content>
					<xsl:attribute name="flow-name">page-footer</xsl:attribute>
					<xsl:attribute name="font-size">8pt</xsl:attribute>
					
					<fo:block>
						<xsl:attribute name="color">grey</xsl:attribute>
						<xsl:attribute name="border-top-style">solid</xsl:attribute>
						<xsl:attribute name="border-top-color">grey</xsl:attribute>
						<xsl:attribute name="text-align-last">justify</xsl:attribute>
					
						<fo:inline>
							 <fo:basic-link>
							 	<xsl:attribute name="external-destination">url('https://github.com/esig/dss')</xsl:attribute>
							 	${text.generated.by.DSS}
							 </fo:basic-link>
						</fo:inline>
						
						<fo:leader/>

						<fo:inline>
							<fo:page-number />
							/
							<fo:page-number-citation>
								<xsl:attribute name="ref-id">theEnd</xsl:attribute>
							</fo:page-number-citation> 
						</fo:inline>
					</fo:block>
				</fo:static-content>

				<fo:flow>
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					
					<xsl:apply-templates select="dss:Signatures"/>
				    <xsl:apply-templates select="dss:BasicBuildingBlocks[@Type='SIGNATURE']"/>
				    <xsl:apply-templates select="dss:BasicBuildingBlocks[@Type='COUNTER_SIGNATURE']"/>
				    <xsl:apply-templates select="dss:BasicBuildingBlocks[@Type='TIMESTAMP']"/>
				    <xsl:apply-templates select="dss:BasicBuildingBlocks[@Type='REVOCATION']"/>
				    
   					<xsl:apply-templates select="dss:QMatrixBlock"/>
					
					<fo:block>
						<xsl:attribute name="id">theEnd</xsl:attribute>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
	<xsl:template match="dss:QMatrixBlock">
		<xsl:apply-templates select="dss:TLAnalysis" />
		<xsl:apply-templates select="dss:SignatureAnalysis" />
	</xsl:template>
	
	<xsl:template match="dss:BasicBuildingBlocks">
		<fo:block>
			<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color">#0066CC</xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
       		<xsl:variable name="bbbId" select="@Id" />
	       	<xsl:variable name="bbbType">
	       		<xsl:choose>
	       			<xsl:when test="@Type = 'TIMESTAMP'"><xsl:value-of select="../dss:Signatures/dss:ValidationProcessTimestamps[@Id = $bbbId]/@Type"/></xsl:when>
	       			<xsl:otherwise><xsl:value-of select="@Type"/></xsl:otherwise>
	       		</xsl:choose>
	       	</xsl:variable>
    		${text.basic.building.blocks}
    		<fo:block>
    			<xsl:attribute name="font-size">7pt</xsl:attribute>
    			<xsl:value-of select="$bbbType"/> - <xsl:value-of select="$bbbId"/>
    		</fo:block>
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
   		</xsl:if>
    </xsl:template>
    
    <xsl:template match="dss:Signatures">
		<fo:block>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color">#0066CC</xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.signature} <xsl:value-of select="@Id" />
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
   		</xsl:if>
    </xsl:template>
    
	<xsl:template match="dss:ValidationProcessBasicSignatures">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
		
    		<xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.validation.process.for.basic.signatures}
    	</fo:block>
       	<xsl:apply-templates/>
       	<fo:block>
			<xsl:attribute name="margin-left">10px</xsl:attribute>	
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
			<xsl:call-template name="analysis-conclusion">
				<xsl:with-param name="Conclusion" select="dss:Conclusion" />
			</xsl:call-template>
		</fo:block>
    </xsl:template>
    
	<xsl:template match="dss:ValidationProcessTimestamps">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
			
			<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.validation.process.for.timestamps} 
    		<fo:block>
	    		<xsl:attribute name="font-size">7pt</xsl:attribute>
	    		<xsl:value-of select="@Type"/> - <xsl:value-of select="@Id"/>
    		</fo:block>
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
        	<fo:block>
				<xsl:attribute name="margin-left">10px</xsl:attribute>	
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				<xsl:call-template name="analysis-conclusion">
					<xsl:with-param name="Conclusion" select="dss:Conclusion" />
				</xsl:call-template>
			</fo:block>
   		</xsl:if>
    </xsl:template>
    
	<xsl:template match="dss:ValidationProcessArchivalData">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.validation.process.for.signatures.with.archival.data}
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
        	<fo:block>
				<xsl:attribute name="margin-left">10px</xsl:attribute>	
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				<xsl:call-template name="analysis-conclusion">
					<xsl:with-param name="Conclusion" select="dss:Conclusion" />
				</xsl:call-template>
			</fo:block>
   		</xsl:if>
    </xsl:template>
    
	<xsl:template match="dss:ValidationProcessLongTermData">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="idSig" select="@Id" />
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
		
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.validation.process.for.signatures.with.time.and.signatures.with.long-term.validation.data}
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
        	<fo:block>
				<xsl:attribute name="margin-left">10px</xsl:attribute>	
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				<xsl:call-template name="analysis-conclusion">
					<xsl:with-param name="Conclusion" select="dss:Conclusion" />
				</xsl:call-template>
			</fo:block>
   		</xsl:if>
    </xsl:template>
    
    <xsl:template match="dss:TLAnalysis">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="idSig" select="@Id" />
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
		
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.tl.analysis}  <xsl:value-of select="@CountryCode"/>
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
        	<fo:block>
				<xsl:attribute name="margin-left">10px</xsl:attribute>	
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				<xsl:call-template name="analysis-conclusion">
					<xsl:with-param name="Conclusion" select="dss:Conclusion" />
				</xsl:call-template>
			</fo:block>
   		</xsl:if>
    </xsl:template>
    
    <xsl:template match="dss:SignatureAnalysis">
		<fo:block>
			<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication/text()"/>
	        <xsl:variable name="idSig" select="@Id" />
	        <xsl:variable name="indicationColor">
	        	<xsl:choose>
					<xsl:when test="$indicationText='PASSED'">green</xsl:when>
					<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
					<xsl:when test="$indicationText='FAILED'">red</xsl:when>
					<xsl:otherwise>grey</xsl:otherwise>
				</xsl:choose>
	        </xsl:variable>
		
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
       		<xsl:attribute name="background-color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
       		<xsl:attribute name="color">white</xsl:attribute>
       		<xsl:attribute name="padding">5px</xsl:attribute>
       		<xsl:attribute name="margin-top">15px</xsl:attribute>
       		<xsl:attribute name="margin-bottom">5px</xsl:attribute>
    		${text.qualification.signature} <xsl:value-of select="@Id"/>
    	</fo:block>
    	<xsl:if test="count(child::*[name(.)!='Conclusion']) &gt; 0">
        	<xsl:apply-templates/>
        	<fo:block>
				<xsl:attribute name="margin-left">10px</xsl:attribute>	
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				<xsl:call-template name="analysis-conclusion">
					<xsl:with-param name="Conclusion" select="dss:Conclusion" />
				</xsl:call-template>
			</fo:block>
   		</xsl:if>
    </xsl:template>
    
    <xsl:template match="dss:Conclusion" />
	
    <xsl:template match="dss:ISC|dss:VCI|dss:RFC|dss:CV|dss:SAV|dss:XCV|dss:SubXCV|dss:PSV|dss:PCV|dss:VTS">
    	<fo:table>
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
			
			<fo:table-column>
				<xsl:attribute name="column-width">70%</xsl:attribute>
			</fo:table-column>
			<fo:table-column>
				<xsl:attribute name="column-width">30%</xsl:attribute>
			</fo:table-column>
			
			<fo:table-body>
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		    	<fo:table-row>
					<fo:table-cell>
						<fo:block>
							<xsl:attribute name="padding-bottom">3px</xsl:attribute>
		    				<xsl:attribute name="font-weight">bold</xsl:attribute>
		    				<xsl:choose>
								<xsl:when test="name(.) = 'ISC'">
									${text.identification.of.the.signing.certificate} : 
								</xsl:when>
								<xsl:when test="name(.) = 'VCI'">
									${text.validation.context.initialization} : 
								</xsl:when>
								<xsl:when test="name(.) = 'RFC'">
									${text.revocation.freshness.checker} :
								</xsl:when>
								<xsl:when test="name(.) = 'CV'">
									${text.cryptographic.verification} : 
								</xsl:when>
								<xsl:when test="name(.) = 'SAV'">
									${text.signature.acceptance.validation} : 
								</xsl:when>
								<xsl:when test="name(.) = 'XCV'">
									${text.X509.certificate.validation} : 
								</xsl:when>
								<xsl:when test="name(.) = 'SubXCV'">
									<xsl:choose>
										<xsl:when test="@TrustAnchor ='true'">Trust Anchor</xsl:when>
										<xsl:otherwise>${text.certificate} : </xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="name(.) = 'PSV'">
									${text.past.signature.validation} : 
								</xsl:when>
								<xsl:when test="name(.) = 'PCV'">
									${text.past.certificate.validation} : 
								</xsl:when>
								<xsl:when test="name(.) = 'VTS'">
									${text.validation.time.sliding} : 
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="name(.)" /> : 
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<xsl:variable name="indicationText" select="dss:Conclusion/dss:Indication"/>
				        <xsl:variable name="indicationColor">
				        	<xsl:choose>
								<xsl:when test="$indicationText='PASSED'">green</xsl:when>
								<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
								<xsl:when test="$indicationText='FAILED'">red</xsl:when>
								<xsl:otherwise>grey</xsl:otherwise>
							</xsl:choose>
				        </xsl:variable>
					
						<fo:block>
							<xsl:attribute name="padding-bottom">3px</xsl:attribute>
		    				<xsl:attribute name="font-weight">bold</xsl:attribute>
							<xsl:attribute name="color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
							
							<xsl:value-of select="dss:Conclusion/dss:Indication" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>	
			</fo:table-body>
		</fo:table>
		<xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="dss:Constraint">
    	<fo:table>
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
			
			<fo:table-column>
				<xsl:attribute name="column-width">70%</xsl:attribute>
			</fo:table-column>
			<fo:table-column>
				<xsl:attribute name="column-width">30%</xsl:attribute>
			</fo:table-column>
			
			<fo:table-body>
    
		    	<fo:table-row>
					<fo:table-cell>
						<fo:block>
							<xsl:attribute name="padding-bottom">3px</xsl:attribute>
							<xsl:value-of select="dss:Name"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block>
							<xsl:attribute name="padding-bottom">3px</xsl:attribute>			
							
							<xsl:variable name="statusText" select="dss:Status"/>
				        	<xsl:choose>
								<xsl:when test="$statusText='OK'">
									<fo:external-graphic>
										<xsl:attribute name="src">data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD//gATQ3JlYXRlZCB3aXRoIEdJTVD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wgARCAAQABADAREAAhEBAxEB/8QAFgABAQEAAAAAAAAAAAAAAAAABQMG/8QAGAEAAwEBAAAAAAAAAAAAAAAAAgMFAAH/2gAMAwEAAhADEAAAAdLOmqO1gM7q/wD/xAAWEAEBAQAAAAAAAAAAAAAAAAAFBAb/2gAIAQEAAQUC0DqKaRliuftrlSzTZZSTzf8A/8QAGxEBAAMAAwEAAAAAAAAAAAAAAgABAxESMUH/2gAIAQMBAT8B20VrqfkK0y4teXGXnp3MovZ8qf/EABwRAQACAgMBAAAAAAAAAAAAAAIAAQMREiEiQf/aAAgBAgEBPwFNu/MFoKgvs08V3qupiCtc1P/EAB8QAAEEAgIDAAAAAAAAAAAAAAIBAwQRABIFMSEigf/aAAgBAQAGPwKRHhK6LLFpTF2tdqtZCb5BxXI8vxqZbEC49MhslKiPrsQAl/MCdPA2mgJC90rroUTP/8QAHRABAAICAgMAAAAAAAAAAAAAAREhADFBUWHB4f/aAAgBAQABPyFSkpuCFW3kXhb8GObEk8X3pdI1EpVUFiKw/TL/AKJ90pXE++c//9oADAMBAAIAAwAAABCDz//EAB4RAQABAwUBAAAAAAAAAAAAAAEAETFRIUFhobHw/9oACAEDAQE/EF9cML6XiLeB2iI6jc+6YNOgeYJ//8QAHxEAAAUEAwAAAAAAAAAAAAAAAAEhQfARUaGxcYHh/9oACAECAQE/EDWqhWjhelnM8BKaNMaxY/tuiH//xAAaEAEBAAMBAQAAAAAAAAAAAAABEQAhMUFh/9oACAEBAAE/EIX+7F5QOAsk0qqszASAiuyKlYZxi5ueqIIqARIzBmq2WHx3FeSlVv8A/9k=</xsl:attribute>
										<xsl:attribute name="content-width">8px</xsl:attribute>
										<xsl:attribute name="height">8px</xsl:attribute>
									</fo:external-graphic>
								</xsl:when>
								<xsl:when test="$statusText='NOT OK'">
									<fo:external-graphic>
										<xsl:attribute name="src">data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD//gATQ3JlYXRlZCB3aXRoIEdJTVD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wgARCAAQABADAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAf/xAAXAQEBAQEAAAAAAAAAAAAAAAABAgQG/9oADAMBAAIQAxAAAAGhYuhWIVn/xAAWEAEBAQAAAAAAAAAAAAAAAAAEBQb/2gAIAQEAAQUCWt+krEW/N1lkfm6xCP0lb//EABoRAAIDAQEAAAAAAAAAAAAAAAIDAAEEERL/2gAIAQMBAT8BAE41CbB7ZRi1a0k1Y+bqAadihBhcsYxisiSUsvV3P//EABkRAQADAQEAAAAAAAAAAAAAAAEAAhEDEv/aAAgBAgEBPwHbdVxlVpfwuzLclwlRvf2mT//EABkQAAMBAQEAAAAAAAAAAAAAAAECBBEAA//aAAgBAQAGPwKuSSsSeU+gKGwuR0kldYr8qMBUtpQnq65JBX5UaQwXShPSV1yCTynwliuFyO//xAAaEAEAAQUAAAAAAAAAAAAAAAABEQAhMUGB/9oACAEBAAE/IRYC1Po1fPAihZC1Po3fPEmhYC0Pp1fPEigZC1vp3fPAmv/aAAwDAQACAAMAAAAQss//xAAbEQACAwEBAQAAAAAAAAAAAAABIRExQQBhkf/aAAgBAwEBPxBI+SSJABeqsst86ucgEB4q+Hzkj5IJgEBaq2w1zK52QAVir6fO/8QAGxEAAgEFAAAAAAAAAAAAAAAAAREAMVGx0fD/2gAIAQIBAT8QbVAUF+1AxIcxNcDQ27UDEgzP/8QAFhABAQEAAAAAAAAAAAAAAAAAASFR/9oACAEBAAE/EGLtJQNViEopiK0gLSUBRaAYC4gkYu0tAxCgGqGoJDAtIQEAiEiDqK3/2Q==</xsl:attribute>
										<xsl:attribute name="content-width">8px</xsl:attribute>
										<xsl:attribute name="height">8px</xsl:attribute>
									</fo:external-graphic>
								</xsl:when>
								<xsl:when test="$statusText='WARNING'">
									<fo:external-graphic>
										<xsl:attribute name="src">data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABIAAD//gATQ3JlYXRlZCB3aXRoIEdJTVD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wgARCAAQABADAREAAhEBAxEB/8QAFgABAQEAAAAAAAAAAAAAAAAAAAMG/8QAFwEBAAMAAAAAAAAAAAAAAAAAAgMEBf/aAAwDAQACEAMQAAAB3mReMyjZn//EABYQAQEBAAAAAAAAAAAAAAAAAAUEA//aAAgBAQABBQK9iphuBioZtMDY9owDZBr/xAAbEQACAwEBAQAAAAAAAAAAAAABAgADEhETQf/aAAgBAwEBPwHAqTRHY6ApsT0Dpz7LLBjIn//EABwRAAICAwEBAAAAAAAAAAAAAAEDAAIREhMxQf/aAAgBAgEBPwHpZ7NAcCJbareVjmFJU3b5EpJZ0Pk//8QAHhAAAgIBBQEAAAAAAAAAAAAAAQMCBAAREhMUMkH/2gAIAQEABj8C6KLMqid5WJQ+nOi+zK2jeFmU/mCyFtbUkzk1R6jhslbVVAzk1f6ln//EABkQAQEBAQEBAAAAAAAAAAAAAAEhEQAxYf/aAAgBAQABPyE3aZBDaojU5TShFTlFVi9sHIps6ny+dgnMlk6H2+9//9oADAMBAAIAAwAAABDnX//EAB4RAAIBAwUAAAAAAAAAAAAAAAERACExgVFh0eHx/9oACAEDAQE/ELoFHniLyinjyCpAN1oE0yQirDXqf//EAB4RAAICAgIDAAAAAAAAAAAAAAERACExQWHRofDx/9oACAECAQE/EDv2JcdqUoCU9v7UAiBN8Z9fiLoQBYeSXXZn/8QAFxABAQEBAAAAAAAAAAAAAAAAAREhAP/aAAgBAQABPxC7JhAIXQQAIRLwNg4AcGghRUgzpJ4npCgihaoSbeJnMHAJFVI1UC7Z3//Z</xsl:attribute>
										<xsl:attribute name="content-width">8px</xsl:attribute>
										<xsl:attribute name="height">8px</xsl:attribute>
									</fo:external-graphic>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="dss:Status" />
								</xsl:otherwise>
				    		</xsl:choose>
							
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
    </xsl:template>
    
    
    <xsl:template name="analysis-conclusion">
        <xsl:param name="Conclusion"/>
        
        <xsl:if test="string-length($Conclusion/dss:Indication) &gt; 0">
	        <fo:table>
				<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
				
				<fo:table-column>
					<xsl:attribute name="column-width">20%</xsl:attribute>
				</fo:table-column>
				<fo:table-column>
					<xsl:attribute name="column-width">70%</xsl:attribute>
				</fo:table-column>
				
				<fo:table-body>
	       			<fo:table-row>
	       				<fo:table-cell>
	       					<fo:block>
	       						<xsl:attribute name="padding-bottom">3px</xsl:attribute>
	       						${text.conclusion} : 
	       					</fo:block>
	       				</fo:table-cell>
	
						<fo:table-cell>
							<xsl:variable name="indicationText" select="$Conclusion/dss:Indication"/>
					        <xsl:variable name="indicationColor">
					        	<xsl:choose>
									<xsl:when test="$indicationText='PASSED'">green</xsl:when>
									<xsl:when test="$indicationText='INDETERMINATE'">orange</xsl:when>
									<xsl:when test="$indicationText='FAILED'">red</xsl:when>
									<xsl:otherwise>grey</xsl:otherwise>
								</xsl:choose>
					        </xsl:variable>
									
							<fo:block>
								<xsl:attribute name="padding-bottom">3px</xsl:attribute>
			    				<xsl:attribute name="font-weight">bold</xsl:attribute>
								<xsl:attribute name="color"><xsl:value-of select="$indicationColor" /></xsl:attribute>
								<xsl:value-of select="$Conclusion/dss:Indication" />
								
								<xsl:if test="string-length($Conclusion/dss:SubIndication) &gt; 0">
									<xsl:text> - </xsl:text>
									<xsl:value-of select="$Conclusion/dss:SubIndication"/>
								</xsl:if>
							</fo:block>
							
							<xsl:if test="string-length($Conclusion/dss:Error) &gt; 0">
								<fo:block>
									<xsl:value-of select="$Conclusion/dss:Error"/>
								</fo:block>
							</xsl:if>
							<xsl:if test="string-length($Conclusion/dss:Warning) &gt; 0">
								<fo:block>
									<xsl:value-of select="$Conclusion/dss:Warning"/>
								</fo:block>
							</xsl:if>
						</fo:table-cell>       			
	       			</fo:table-row>
	       		</fo:table-body>
	       	</fo:table>
		</xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

