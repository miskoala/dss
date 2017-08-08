package eu.europa.esig.dss.locale;

import java.io.InputStream;
import java.text.MessageFormat;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DSSLocale {

	private static final Logger LOG = LoggerFactory.getLogger(DSSLocale.class);
	public static final String DEFAULT_LOCALE = "default";
	private static DSSLocale defaultDSSLocale;
	private static Object mutex = new Object();

	private static Map<String, Properties> messagesMap = new ConcurrentHashMap<String, Properties>();

	private String lang;
	private String resourceNamePrefix = "/validationPolicyMessages";

	public DSSLocale() {
		init(DEFAULT_LOCALE);
	}

	public DSSLocale(String parLang) {
		init(parLang);
	}

	public DSSLocale(String parLang, String resourceNamePrefix) {
		this.resourceNamePrefix = resourceNamePrefix;
		init(parLang);
	}

	private void init(String parLang) {
		if (parLang == null) {
			parLang = DEFAULT_LOCALE;
		}
		this.lang = parLang;
		InputStream in = null;
		if (!messagesMap.containsKey(parLang)) {
			String suffix = DEFAULT_LOCALE.equals(lang) ? "" : "_" + lang;
			suffix += ".properties";
			String resourceFile = resourceNamePrefix + suffix;
			try {
				in = DSSLocale.class.getResourceAsStream(resourceFile);
				Properties prop = new Properties();
				prop.load(in);
				messagesMap.put(lang, prop);
				in.close();
			} catch (Exception e) {
				LOG.warn("Cannot load properties file (" + resourceFile + ") for language - " + lang);
			} finally {
				try {
					if (in != null) {
						in.close();
					}
				} catch (Exception e) {
				}
			}
		}
	}

	public String getLang() {
		return lang;
	}

	public String getLocalizedMessage(String key) {
		LOG.debug("getLocalizedMessage( " + key + ")");
		Properties prop = null;
		if (messagesMap.containsKey(lang)) {
			prop = messagesMap.get(lang);
			// TODO load default locale ???? or return key
			// if (prop == null) {
			// prop = messagesMap.get(DEFAULT_LOCALE);
			// }
		}
		if (prop != null) {
			String localeString = prop.getProperty(key);
			if (localeString == null) {
				LOG.warn("Cannot find key ( \"" + key + "\") in properties file for language - " + lang);
				return key;
			}
			return localeString;
		}
		LOG.warn("Properties file for language \"" + lang + "\" not loaded, returning key");
		return key;
	}
    public String getLocalizedMessage(String key, Object ... arguments) {
        return MessageFormat.format(getLocalizedMessage(key), arguments);
    }
	public static DSSLocale getDefaultDSSLocale() {
		if (defaultDSSLocale == null) {
			synchronized (mutex) {
				defaultDSSLocale = new DSSLocale(DEFAULT_LOCALE);
			}
		}
		return defaultDSSLocale;
	}

	public void setResourceNamePrefix(String resourceNamePrefix) {
		this.resourceNamePrefix = resourceNamePrefix;
	}

}
