package eu.europa.esig.dss.locale;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.w3c.dom.Document;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.engine.util.JRXmlUtils;

public class LocaleUtils {
	
	public static void simpleReportToPdf(InputStream simpleReportXmlDataInputStream, OutputStream pdfOutputStream, DSSLocale locale) throws JRException {
		InputStream report = JRLoader.getLocationInputStream("sr.jasper");
		JasperPrint jasperPrint = fillReport(simpleReportXmlDataInputStream, report, locale);
		LocaleUtils.toPdf(jasperPrint, pdfOutputStream);
	}
	
	public static JasperPrint fillReport(InputStream reportData, InputStream report, DSSLocale locale) throws JRException
	{
		//long start = System.currentTimeMillis();
		Map<String, Object> params = new HashMap<String, Object>();
		//Document document = JRXmlUtils.parse(JRLoader.getLocationInputStream(reportData));
		Document document = JRXmlUtils.parse(reportData);
		params.put(JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, document);
		params.put(JRXPathQueryExecuterFactory.XML_DATE_PATTERN, "yyyy-MM-dd");
		params.put(JRXPathQueryExecuterFactory.XML_NUMBER_PATTERN, "#,##0.##");
		params.put(JRXPathQueryExecuterFactory.XML_LOCALE, locale.getLocale());
		params.put(JRParameter.REPORT_LOCALE, locale.getLocale());
		params.put("net.sf.jasperreports.default.font.name","DejaVu Sans");
		params.put("net.sf.jasperreports.export.character.encoding", "UTF-8");
		params.put("REPORT_RESOURCE_BUNDLE",locale.getResourceBundle());
		
		//JasperFillManager.fillReportToFile("build/reports/CustomersReport.jasper", params);
		return JasperFillManager.fillReport(report, params);
		//System.err.println("Filling time : " + (System.currentTimeMillis() - start));
	}
	
	public static void toPdf(JasperPrint jasperPrint, OutputStream pdfOutputStream) throws JRException
	{
		//long start = System.currentTimeMillis();
		JasperExportManager.exportReportToPdfStream(jasperPrint, pdfOutputStream);
		//System.err.println("PDF creation time : " + (System.currentTimeMillis() - start));
	}
}
