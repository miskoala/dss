package eu.europa.esig.dss.locale;

import java.text.MessageFormat;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DSSLocale {

	private static final Logger LOG = LoggerFactory.getLogger(DSSLocale.class);

	public static final String DEFAULT = "default";

	private static DSSLocale defaultDSSLocale;

	private ResourceBundle resourceBundle;

	private String resourceNamePrefix = "validationPolicyMessages";

	public DSSLocale() {
		init(DEFAULT);
	}

	public DSSLocale(String lang) {
		init(lang);
	}

	public DSSLocale(String parLang, String resourceNamePrefixString) {
		resourceNamePrefix = resourceNamePrefixString;
		init(parLang);
	}

	private void init(String lang) {
		if (DEFAULT.equals(lang)) {
			resourceBundle = ResourceBundle.getBundle(resourceNamePrefix, Locale.ROOT, new ResourceBundle.Control() {
				@Override
				public List<Locale> getCandidateLocales(String name, Locale locale) {
					return Collections.singletonList(Locale.ROOT);
				}
			});
		} else {
			resourceBundle = ResourceBundle.getBundle(resourceNamePrefix, new Locale(lang));
		}
		if (LOG.isDebugEnabled() || LOG.isWarnEnabled()) {
			if (resourceBundle.getLocale().getLanguage().equals(lang)
					|| ("".equals(resourceBundle.getLocale().getLanguage()) && DEFAULT.equalsIgnoreCase(lang))) {
				LOG.debug("Resource bundle for expected language " + lang + " loaded");
			} else {
				String locLang = resourceBundle.getLocale().getLanguage().equals(Locale.ROOT.getLanguage()) ? "ROOT"
						: resourceBundle.getLocale().getLanguage();
				LOG.warn("Resource bundle for expected language NOT loaded");
				LOG.warn("Loaded resource bundle for language " + locLang + " (expected language was " + lang + ")");
			}
		}
	}

	public String getLocalizedMessage(String key) {
		try {
			return resourceBundle.getString(key);
		} catch (Exception e) {
			if (LOG.isWarnEnabled()) {
				String locLang = resourceBundle.getLocale().getLanguage().equals(Locale.ROOT.getLanguage()) ? "ROOT"
						: resourceBundle.getLocale().getLanguage();
				LOG.warn("Expected key (" + key + ") not found in resource bundle for language " + locLang);
				LOG.warn(e.getMessage() + " - returning key");
			}
			return key;
		}

	}

	public String getLocalizedMessage(String key, Object... arguments) {
		return MessageFormat.format(getLocalizedMessage(key), arguments);
	}

	public static DSSLocale getDefaultDSSLocale() {
		if (defaultDSSLocale == null) {
			defaultDSSLocale = new DSSLocale();
		}
		return defaultDSSLocale;
	}
}
