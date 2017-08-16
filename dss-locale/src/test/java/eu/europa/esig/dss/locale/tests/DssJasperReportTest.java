package eu.europa.esig.dss.locale.tests;

import static org.junit.Assert.*;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.pdfbox.io.RandomAccessBufferedFileInputStream;
import org.apache.pdfbox.io.RandomAccessFile;
import org.apache.pdfbox.io.RandomAccessRead;
import org.apache.pdfbox.pdfparser.PDFParser;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.junit.Test;

import eu.europa.esig.dss.locale.DSSLocale;
import eu.europa.esig.dss.locale.LocaleUtils;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.util.JRLoader;

public class DssJasperReportTest {

	@Test
	public void plPdfTest() throws JRException, IOException {
		DSSLocale dssLocale = new DSSLocale("pl", "testReport");
		//Locale l = dssLocale.getLocale();
		InputStream reportData = JRLoader.getLocationInputStream("data/_03sr.xml");
		InputStream report = JRLoader.getLocationInputStream("sr.jasper");
		JasperPrint jasperPrint = LocaleUtils.fillReport(reportData, report, dssLocale);

		FileOutputStream pdfOutputStream = new FileOutputStream("target/simpleReportTest_pl.pdf");
		LocaleUtils.toPdf(jasperPrint, pdfOutputStream);
		pdfOutputStream.close();
		
		RandomAccessBufferedFileInputStream pdf = new RandomAccessBufferedFileInputStream("target/simpleReportTest_pl.pdf");
		PDFParser testPDF = new PDFParser((RandomAccessRead) pdf);
		testPDF.parse();
		PDDocument pdfDoc = testPDF.getPDDocument();
		String testText = new PDFTextStripper().getText(pdfDoc);
		pdfDoc.close();
		pdf.close();

		assertTrue(testText.contains("Test - Raport walidacji podpisanego dokumentu"));
		assertTrue(testText.contains("Ścieżka certyfikacji:"));
		//assertTrue(testText.contains("Ścieżka to jest path"));
		 
	}

	@Test
	public void enPdftest() throws JRException, IOException {
		DSSLocale dssLocale = new DSSLocale("en", "testReport");
		//Locale locale = dssLocale.getLocale();
		InputStream reportData = JRLoader.getLocationInputStream("data/_03sr.xml");
		InputStream report = JRLoader.getLocationInputStream("sr.jasper");
		JasperPrint jasperPrint = LocaleUtils.fillReport(reportData, report, dssLocale);

		FileOutputStream pdfOutputStream = new FileOutputStream("target/simpleReportTest_en.pdf");
		LocaleUtils.toPdf(jasperPrint, pdfOutputStream);
		pdfOutputStream.close();

		RandomAccessBufferedFileInputStream pdf = new RandomAccessBufferedFileInputStream("target/simpleReportTest_en.pdf");
		PDFParser testPDF = new PDFParser((RandomAccessRead) pdf);
		testPDF.parse();
		PDDocument pdfDoc = testPDF.getPDDocument();
		String testText = new PDFTextStripper().getText(pdfDoc);
		pdfDoc.close();
		pdf.close();
		assertTrue(testText.contains("[en] Test - Signed Document Validation Simple Report"));
		assertTrue(testText.contains("[en] Signature format:"));

	}
	
	@Test
	public void defaultPdftest() throws JRException, IOException {
		DSSLocale dssLocale = new DSSLocale(DSSLocale.DEFAULT, "testReport");
		//Locale locale = dssLocale.getLocale();
		InputStream reportData = JRLoader.getLocationInputStream("data/_03sr.xml");
		InputStream report = JRLoader.getLocationInputStream("sr.jasper");
		JasperPrint jasperPrint = LocaleUtils.fillReport(reportData, report, dssLocale);

		FileOutputStream pdfOutputStream = new FileOutputStream("target/simpleReportTest_default.pdf");
		LocaleUtils.toPdf(jasperPrint, pdfOutputStream);
		pdfOutputStream.close();
		
		RandomAccessBufferedFileInputStream pdf = new RandomAccessBufferedFileInputStream("target/simpleReportTest_default.pdf");
		PDFParser testPDF = new PDFParser((RandomAccessRead) pdf);
		testPDF.parse();
		PDDocument pdfDoc = testPDF.getPDDocument();
		String testText = new PDFTextStripper().getText(pdfDoc);
		pdfDoc.close();
		pdf.close();
		assertTrue(testText.contains("[def] Test - Signed Document Validation Simple Report"));
		assertTrue(testText.contains("[def] Certificate chain:"));
	}
	@Test
	public void simpleReportToPdfTest() throws JRException, IOException {
		DSSLocale dssLocale = new DSSLocale(DSSLocale.DEFAULT, "report");
		InputStream reportData = DssJasperReportTest.class.getResourceAsStream("/data/_03sr.xml");
		FileOutputStream pdfOutputStream = new FileOutputStream("target/simpleReportTestSimple.pdf");
		LocaleUtils.simpleReportToPdf(reportData, pdfOutputStream, dssLocale);
		pdfOutputStream.close();
	}
}
