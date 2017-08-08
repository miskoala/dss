package eu.europa.esig.dss.locale;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class DSSLocaleResourceNotExistTests {

	@Test
	public void defaultLocaleNotExistingFileTest() {
		DSSLocale defaultLocale = new DSSLocale(DSSLocale.DEFAULT_LOCALE,"/locale/notExist");
		assertEquals("TEST_KEY", defaultLocale.getLocalizedMessage("TEST_KEY"));
	}
	
}
