package eu.europa.esig.dss.locale.tests;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.Set;

import org.apache.fop.fonts.apps.TTFReader;

public class TranslationsTools {
	public static void main(String[] args) throws IOException {
		TranslationsTools tt = new TranslationsTools();
		tt.showNotTranslated("/i18n", "pl");
		//tt.showNotTranslated("/locale/testPolicyMessages", "pl");
	}
	public void showNotTranslated(String resourceNamePrefix, String lang) throws IOException {
		
		
		
		InputStream isD = TranslationsTools.class.getResourceAsStream(resourceNamePrefix+".properties");
		Properties propD= new Properties();
		propD.load(isD);
		isD.close();

		InputStream isL = TranslationsTools.class.getResourceAsStream(resourceNamePrefix+"_"+lang+".properties");
		Properties propL= new Properties();
		propL.load(isL);
		isL.close();
		System.out.println("----- NOT TRANSLATED KEYS for language "+lang);
		Set<Object> defaultKeys = propD.keySet();
		for (Object object : defaultKeys) {
			String defaultKey = (String) object;
			//System.out.println("key="+defaultKey);
			//System.out.println(propL.containsKey(defaultKey));
			if(!propL.containsKey(defaultKey)) {
				System.out.println(defaultKey+"="+propD.getProperty(defaultKey));
			}

		}
		
		
	}
}
