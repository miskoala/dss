package eu.europa.esig.dss.locale.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.MissingResourceException;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

import eu.europa.esig.dss.locale.DSSLocale;
import eu.europa.esig.dss.locale.tests.utils.FOPService;

public class DSSLocaleTest {
	
	private Object mutex= new Object();
	
	@Test
	public void defaultFopSimpleTest() throws Exception {
		DSSLocale locale = new DSSLocale();
		FOPService fs = new FOPService(locale);
		InputStream dataIs = DSSLocaleTest.class.getResourceAsStream("/data/_03sr.xml");
		String result = IOUtils.toString(dataIs, "UTF-8");
		fs.generateSimpleReport(result, new FileOutputStream("target/fopSimple_default.pdf"));
	}

	@Test
	public void plFopSimpleTest() throws Exception {
		DSSLocale locale = new DSSLocale("pl");
		FOPService fs = new FOPService(locale);
		InputStream dataIs = DSSLocaleTest.class.getResourceAsStream("/data/_03sr.xml");
		String result = IOUtils.toString(dataIs, "UTF-8");
		fs.generateSimpleReport(result, new FileOutputStream("target/fopSimple_pl.pdf"));
	}
	@Test
	public void enFopSimpleTest() throws Exception {
		DSSLocale locale = new DSSLocale("en");
		FOPService fs = new FOPService(locale);
		InputStream dataIs = DSSLocaleTest.class.getResourceAsStream("/data/_03sr.xml");
		String result = IOUtils.toString(dataIs, "UTF-8");
		fs.generateSimpleReport(result, new FileOutputStream("target/fopSimple_en.pdf"));
	}
	
	
	@Test
	public void defaultLocaleExistingKeyTest() {
		DSSLocale defaultLocale = new DSSLocale(DSSLocale.DEFAULT,"locale/testPolicyMessages");
		assertEquals("default - Test message", defaultLocale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void defaultLocaleNotExistingKeyTest() {
		DSSLocale defaultLocale = new DSSLocale(DSSLocale.DEFAULT,"locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", defaultLocale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void plLocaleExistingKeyTest() {
		DSSLocale plLocale = new DSSLocale("pl","locale/testPolicyMessages");
		assertEquals("pl - Wiadomość testowa", plLocale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void plLocaleNotExistingKeyTest() {
		DSSLocale plLocale = new DSSLocale("pl","locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", plLocale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void enLocaleExistingKeyTest() {
		DSSLocale locale = new DSSLocale("en","locale/testPolicyMessages");
		assertEquals("en - Test message", locale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void enLocaleNotExistingKeyTest() {
		DSSLocale locale = new DSSLocale("en","locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", locale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void defaultXsltSimpleReportHtmlTest() throws IOException {
		DSSLocale locale = new DSSLocale();
		InputStream is = locale.getXsltSimpleReportHtml();
		
		String result = IOUtils.toString(is, "UTF-8");
		assertTrue(result.contains("Validation policy"));
		assertTrue(result.contains("Document name:"));
	}
	@Test
	public void enXsltSimpleReportHtmlTest() throws IOException {
		DSSLocale locale = new DSSLocale("en");
		InputStream is = locale.getXsltSimpleReportHtml();
		
		String result = IOUtils.toString(is, "UTF-8");
		assertTrue(result.contains("Validation policy"));
		assertTrue(result.contains("Document name:"));
		assertTrue(result.contains(" valid signatures, out of "));
		assertTrue(result.contains("Certificate chain:"));
	}
	@Test
	public void plXsltSimpleReportHtmlTest() throws IOException {
		DSSLocale locale = new DSSLocale("pl");
		InputStream is = locale.getXsltSimpleReportHtml();
		
		String result = IOUtils.toString(is, "UTF-8");
		assertTrue(result.contains("Polityka weryfikacji : "));
		assertTrue(result.contains("Nazwa dokumentu:"));
	}
	
	
	@Test
	public void notExistLanguageTest() {
		synchronized (mutex) {
			Locale.setDefault(new Locale("en"));
			
			DSSLocale localeNotExisting = new DSSLocale("not_existing_language","locale/testPolicyMessages");
			String message=localeNotExisting.getLocalizedMessage("TEST_KEY");
			
			assertEquals("en - Test message",message);
			
			DSSLocale localeDefault = new DSSLocale(Locale.getDefault().getLanguage(),"locale/testPolicyMessages");
			
			assertEquals(message,localeDefault.getLocalizedMessage("TEST_KEY"));
		}
	}
	@Test
	public void notExistLanguageNotSuportedLocaleTest() {
		synchronized (mutex) {
			Locale.setDefault(Locale.FRANCE);
			
			DSSLocale localeNotExisting = new DSSLocale("not_existing_language","locale/testPolicyMessages");
			String message=localeNotExisting.getLocalizedMessage("TEST_KEY");
			assertNotNull(message);
			assertEquals("default - Test message",message);
			
			DSSLocale localeDefault = new DSSLocale(Locale.getDefault().getLanguage(),"locale/testPolicyMessages");
			assertNotNull(localeDefault.getLocalizedMessage("TEST_KEY"));
			
			assertEquals(message,localeDefault.getLocalizedMessage("TEST_KEY"));
		}
	}

	@Test
	public void notExistLanguageNotExistKeyTest() {
		synchronized (mutex) {
			Locale.setDefault(new Locale("en"));
			DSSLocale localeNotExisting = new DSSLocale("not_existing_language","locale/testPolicyMessages");
			String message=localeNotExisting.getLocalizedMessage("NOT_EXISTING_KEY");
			assertEquals("NOT_EXISTING_KEY",message);
		}
	}
	
	
	
	@Test(expected=MissingResourceException.class)
	public void defaultLocaleNotExistingFileTest() {
		new DSSLocale(DSSLocale.DEFAULT,"locale/notExist");
	}

}
