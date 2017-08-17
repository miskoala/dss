package eu.europa.esig.dss.locale.tests.utils;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;

import javax.annotation.PostConstruct;
import javax.xml.XMLConstants;
import javax.xml.transform.Result;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.IOUtils;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.FopFactoryBuilder;
import org.apache.fop.apps.MimeConstants;
import org.w3c.dom.Document;

import eu.europa.esig.dss.locale.DSSLocale;

public class FOPService {

	private FopFactory fopFactory;
	private FOUserAgent foUserAgent;
	private Templates templateSimpleReport;
	private Templates templateDetailedReport;
	private DSSLocale dssLocale;

	
	
	public FOPService(DSSLocale dssLocale) throws Exception {
		super();
		this.dssLocale = dssLocale;
		init();
	}

	private void init() throws Exception {

		FopFactoryBuilder builder = new FopFactoryBuilder(new File(".").toURI());
		builder.setAccessibility(true);

		fopFactory = builder.build();

		foUserAgent = fopFactory.newFOUserAgent();
		foUserAgent.setCreator("DSS Webapp");
		foUserAgent.setAccessibility(true);

		TransformerFactory transformerFactory = getSecureTransformerFactory();

		//InputStream simpleIS = FOPService.class.getResourceAsStream("/xslt/pdf/simple-report.xslt");
		InputStream simpleIS = dssLocale.getXsltSimpleReportPdf();
		templateSimpleReport = transformerFactory.newTemplates(new StreamSource(simpleIS));
		IOUtils.closeQuietly(simpleIS);

		//InputStream detailedIS = FOPService.class.getResourceAsStream("/xslt/pdf/detailed-report.xslt");
		InputStream detailedIS = dssLocale.getXsltDetailedReportPdf();
		templateDetailedReport = transformerFactory.newTemplates(new StreamSource(detailedIS));
		IOUtils.closeQuietly(detailedIS);
	}

	public void generateSimpleReport(String simpleReport, OutputStream os) throws Exception {
		Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, os);
		Result res = new SAXResult(fop.getDefaultHandler());
		Transformer transformer = templateSimpleReport.newTransformer();
		//transformer.setErrorListener(new DSSXmlErrorListener());
		transformer.transform(new StreamSource(new StringReader(simpleReport)), res);
	}

	public void generateSimpleReport(Document dom, OutputStream os) throws Exception {
		Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, os);
		Result res = new SAXResult(fop.getDefaultHandler());
		Transformer transformer = templateSimpleReport.newTransformer();
		//transformer.setErrorListener(new DSSXmlErrorListener());
		transformer.transform(new DOMSource(dom), res);
	}

	public void generateDetailedReport(String detailedReport, OutputStream os) throws Exception {
		Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, os);
		Result res = new SAXResult(fop.getDefaultHandler());
		Transformer transformer = templateDetailedReport.newTransformer();
		//transformer.setErrorListener(new DSSXmlErrorListener());
		transformer.transform(new StreamSource(new StringReader(detailedReport)), res);
	}
	public static TransformerFactory getSecureTransformerFactory() throws Exception {
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		try {
			transformerFactory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
		} catch (TransformerConfigurationException e) {
			throw new Exception(e);
		}
		//transformerFactory.setErrorListener(new DSSXmlErrorListener());
		return transformerFactory;
	}
}
