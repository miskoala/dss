package eu.europa.esig.dss.locale;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.Locale;
import java.util.MissingResourceException;

import org.junit.Test;

public class DSSLocaleTest {
	
	private Object mutex= new Object();
	
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
