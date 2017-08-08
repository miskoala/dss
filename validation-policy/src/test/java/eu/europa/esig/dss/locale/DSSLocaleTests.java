package eu.europa.esig.dss.locale;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class DSSLocaleTests {
	
	
	

	@Test
	public void defaultLocaleExistingKeyTest() {
		DSSLocale defaultLocale = new DSSLocale(DSSLocale.DEFAULT_LOCALE,"/locale/testPolicyMessages");
		assertEquals("default - Test message", defaultLocale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void defaultLocaleNotExistingKeyTest() {
		DSSLocale defaultLocale = new DSSLocale(DSSLocale.DEFAULT_LOCALE,"/locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", defaultLocale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void plLocaleExistingKeyTest() {
		DSSLocale plLocale = new DSSLocale("pl","/locale/testPolicyMessages");
		assertEquals("pl - Wiadomość testowa", plLocale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void plLocaleNotExistingKeyTest() {
		DSSLocale plLocale = new DSSLocale("pl","/locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", plLocale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void enLocaleExistingKeyTest() {
		DSSLocale locale = new DSSLocale("en","/locale/testPolicyMessages");
		assertEquals("en - Test message", locale.getLocalizedMessage("TEST_KEY"));
	}
	@Test
	public void enLocaleNotExistingKeyTest() {
		DSSLocale locale = new DSSLocale("en","/locale/testPolicyMessages");
		assertEquals("NOT_EXISTING_KEY", locale.getLocalizedMessage("NOT_EXISTING_KEY"));
	}
	@Test
	public void propertiesFileNotExistTest() {
		DSSLocale locale = new DSSLocale("not_existing_language","/locale/testPolicyMessages");
		assertEquals("TEST_KEY", locale.getLocalizedMessage("TEST_KEY"));
	}
}
