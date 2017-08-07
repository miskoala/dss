package eu.europa.esig.dss.validation;

import java.text.MessageFormat;
import java.util.ResourceBundle;

public final class I18n {
    private I18n() {
    }

    private static ResourceBundle bundle;

    public static String getMessage(String key) {
        if(bundle == null) {
            bundle = ResourceBundle.getBundle("validationPolicyMessages");
        }
        return bundle.getString(key);
    }

    public static String getMessage(String key, Object ... arguments) {
        return MessageFormat.format(getMessage(key), arguments);
    }
}