<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dss="http://dss.esig.europa.eu/validation/simple-report">
                
	<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:template match="/dss:SimpleReport">
	    <xsl:apply-templates/>
	    <xsl:call-template name="documentInformation"/>
    </xsl:template>

    <xsl:template match="dss:DocumentName"/>
    <xsl:template match="dss:SignatureFormat"/>
    <xsl:template match="dss:SignaturesCount"/>
    <xsl:template match="dss:ValidSignaturesCount"/>
    <xsl:template match="dss:ValidationTime"/>
    <xsl:template match="dss:ContainerType"/>

    <xsl:template match="dss:Policy">
		<div>
    		<xsl:attribute name="class">panel panel-primary</xsl:attribute>
    		<div>
    			<xsl:attribute name="class">panel-heading</xsl:attribute>
	    		<xsl:attribute name="data-target">#collapsePolicy</xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
    			${text.validation.policy} : <xsl:value-of select="dss:PolicyName"/>
	        </div>
    		<div>
    			<xsl:attribute name="class">panel-body collapse in</xsl:attribute>
	        	<xsl:attribute name="id">collapsePolicy</xsl:attribute>
	        	<p>
	        		<xsl:value-of select="dss:PolicyDescription"/>
	        	</p>
    		</div>
    	</div>
    </xsl:template>

    <xsl:template match="dss:Signature">
        <xsl:variable name="indicationText" select="dss:Indication/text()"/>
        <xsl:variable name="idSig" select="@Id" />
        <xsl:variable name="indicationCssClass">
        	<xsl:choose>
				<xsl:when test="$indicationText='TOTAL_PASSED'">success</xsl:when>
				<xsl:when test="$indicationText='INDETERMINATE'">warning</xsl:when>
				<xsl:when test="$indicationText='TOTAL_FAILED'">danger</xsl:when>
			</xsl:choose>
        </xsl:variable>
        
        <div>
    		<xsl:attribute name="class">panel panel-<xsl:value-of select="$indicationCssClass" /></xsl:attribute>
    		<div>
    			<xsl:attribute name="class">panel-heading</xsl:attribute>
	    		<xsl:attribute name="data-target">#collapseSig<xsl:value-of select="$idSig" /></xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
    			${text.signature} <xsl:value-of select="$idSig" />
	        </div>
    		<div>
    			<xsl:attribute name="class">panel-body collapse in</xsl:attribute>
				<xsl:attribute name="id">collapseSig<xsl:value-of select="$idSig" /></xsl:attribute>
				
			    <xsl:apply-templates select="dss:Filename" />
			    <xsl:apply-templates select="dss:SignatureLevel" />

		        <dl>
		    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.signature.format}:</dt>
		            <dd><xsl:value-of select="@SignatureFormat"/></dd>
		        </dl>
			
				<dl>
					<xsl:attribute name="class">dl-horizontal</xsl:attribute>
					<dt>${text.indication}:</dt>
					<dd>
						<xsl:attribute name="class">text-<xsl:value-of select="$indicationCssClass" /></xsl:attribute>
						<xsl:choose>
							<xsl:when test="$indicationText='TOTAL_PASSED'">
								<span>
									<xsl:attribute name="class">glyphicon glyphicon-ok-sign</xsl:attribute>
								</span>
							</xsl:when>
							<xsl:when test="$indicationText='INDETERMINATE'">
								<span>
									<xsl:attribute name="class">glyphicon glyphicon-question-sign</xsl:attribute>
								</span>
							</xsl:when>
							<xsl:when test="$indicationText='TOTAL_FAILED'">
								<span>
									<xsl:attribute name="class">glyphicon glyphicon-remove-sign</xsl:attribute>
								</span>
							</xsl:when>
						</xsl:choose>
			
						<xsl:text> </xsl:text>
						<xsl:value-of select="dss:Indication" />
					</dd>
				</dl>   
		        
		        <xsl:apply-templates select="dss:SubIndication">
		            <xsl:with-param name="indicationClass" select="$indicationCssClass"/>
		        </xsl:apply-templates>

			    <xsl:apply-templates select="dss:Errors" />
			    <xsl:apply-templates select="dss:Warnings" />
		        <xsl:apply-templates select="dss:Infos" />
		        
		        <dl>
	        		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.certificate.chain}:</dt>
		            <xsl:choose>
			            <xsl:when test="dss:CertificateChain">
				            <xsl:for-each select="dss:CertificateChain/dss:Certificate">
				            	<xsl:variable name="index" select="position()"/>
				        		<dd>
			        				<span><xsl:attribute name="class"> glyphicon glyphicon-link</xsl:attribute></span>
				        			<xsl:choose>
				        				<xsl:when test="$index = 1">
				        					<b> <xsl:value-of select="dss:qualifiedName" /></b>
				        				</xsl:when>
				        				<xsl:otherwise>
											<xsl:value-of select="dss:qualifiedName" />				        				
				        				</xsl:otherwise>
				        			</xsl:choose>
			        			</dd>
				        	</xsl:for-each>
			        	</xsl:when>
			        	<xsl:otherwise>
			        		<dd>/</dd>
			        	</xsl:otherwise>
		        	</xsl:choose>
	        	</dl>
		        
		        <dl>
		    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.on.claimed.time}:</dt>
		            <dd><xsl:value-of select="dss:SigningTime"/></dd>
		            <dd>${text.on.claimed.time.desc}</dd>
		        </dl>
		        
		        <dl>
		    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.signature.position}:</dt>
		            <dd><xsl:value-of select="count(preceding-sibling::dss:Signature) + 1"/> ${text.out.of} <xsl:value-of select="count(ancestor::*/dss:Signature)"/></dd>
		        </dl>
		        
		        <xsl:for-each select="dss:SignatureScope">
			        <dl>
			    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			            <dt>${text.signature.scope}:</dt>
			            <dd><xsl:value-of select="@name"/> (<xsl:value-of select="@scope"/>)</dd>
			            <dd><xsl:value-of select="."/></dd>
			        </dl>
		        </xsl:for-each>
		        
    		</div>
    	</div>
    </xsl:template>
    
	<xsl:template match="dss:SignatureLevel">
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
            <dt>${text.qualification}:</dt>
            <dd>
				<xsl:value-of select="." />
				<span>
	    			<xsl:attribute name="class">glyphicon glyphicon-info-sign text-info</xsl:attribute>
					<xsl:attribute name="style">margin-left : 10px</xsl:attribute>
					<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
					<xsl:attribute name="data-placement">right</xsl:attribute>
					<xsl:attribute name="title"><xsl:value-of select="@description" /></xsl:attribute>
	    		</span>					
        	</dd>
        </dl>
	</xsl:template>
	
	<xsl:template match="dss:Filename">
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
            <dt>${text.signature.filename}:</dt>
            <dd>
					<xsl:value-of select="." />
        	</dd>
        </dl>
	</xsl:template>

	<xsl:template match="dss:SubIndication">
		<xsl:param name="indicationClass" />
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			<dt>${text.sub.indication}:</dt>
			<dd>
				<xsl:attribute name="class">text-<xsl:value-of select="$indicationClass" /></xsl:attribute>
				<xsl:value-of select="." />
			</dd>
		</dl>
	</xsl:template>
	
	<xsl:template match="dss:Errors">
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			<dt></dt>
			<dd>
				<xsl:attribute name="class">text-danger</xsl:attribute>
				<xsl:value-of select="." />
			</dd>
		</dl>
	</xsl:template>
	
	<xsl:template match="dss:Warnings">
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			<dt></dt>
			<dd>
				<xsl:attribute name="class">text-warning</xsl:attribute>
				<xsl:value-of select="." />
			</dd>
		</dl>
	</xsl:template>
	
	<xsl:template match="dss:Infos">
		<dl>
    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			<dt></dt>
			<dd>
				<xsl:value-of select="." />
			</dd>
		</dl>
	</xsl:template>

    <xsl:template name="documentInformation">
		<div>
    		<xsl:attribute name="class">panel panel-primary</xsl:attribute>
    		<div>
    			<xsl:attribute name="class">panel-heading</xsl:attribute>
	    		<xsl:attribute name="data-target">#collapseInfo</xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
    			${text.document.informations}
	        </div>
    		<div>
    			<xsl:attribute name="class">panel-body collapse in</xsl:attribute>
	        	<xsl:attribute name="id">collapseInfo</xsl:attribute>
	        	
				<xsl:if test="dss:ContainerType">
			        <dl>
			    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
			            <dt>${text.container.type}:</dt>
			            <dd><xsl:value-of select="dss:ContainerType"/></dd>
			        </dl>
		        </xsl:if>
	        	<dl>
		    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.signatures.status}:</dt>
		            <dd>
		                <xsl:choose>
		                    <xsl:when test="dss:ValidSignaturesCount = dss:SignaturesCount">
		                        <xsl:attribute name="class">text-success</xsl:attribute>
		                    </xsl:when>
		                    <xsl:otherwise>
		                        <xsl:attribute name="class">text-warning</xsl:attribute>
		                    </xsl:otherwise>
		                </xsl:choose>
		                <xsl:value-of select="dss:ValidSignaturesCount"/> ${text.valid.signatures.out.of} <xsl:value-of select="dss:SignaturesCount"/>
		            </dd>
		        </dl>
		        <dl>
		    		<xsl:attribute name="class">dl-horizontal</xsl:attribute>
		            <dt>${text.document.name}:</dt>
		            <dd><xsl:value-of select="dss:DocumentName"/></dd>
		        </dl>
		        
    		</div>
    	</div>
    </xsl:template>
</xsl:stylesheet>