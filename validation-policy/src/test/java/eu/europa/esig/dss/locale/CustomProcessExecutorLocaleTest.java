package eu.europa.esig.dss.locale;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Locale;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.junit.Test;

import eu.europa.esig.dss.jaxb.diagnostic.DiagnosticData;
import eu.europa.esig.dss.utils.Utils;
import eu.europa.esig.dss.validation.executor.CustomProcessExecutor;
import eu.europa.esig.dss.validation.policy.EtsiValidationPolicy;
import eu.europa.esig.dss.validation.reports.Reports;
import eu.europa.esig.jaxb.policy.ConstraintsParameters;

public class CustomProcessExecutorLocaleTest {
	private static String PL_STRING = "ąśężółńĄŚĘŻÓŁŃ - Polskie znaki";
	private static String EN_STRING = "en - Test message for BBB_XCV_PSEUDO_USE_ANS";
	private static String DEFAULT_STRING = "default - Test message for BBB_XCV_PSEUDO_USE_ANS";

	@Test
	public void defaultLocaleTest1() throws Exception {
		FileInputStream fis = new FileInputStream("src/test/resources/locale/dd.xml");
		DiagnosticData diagnosticData = getJAXBObjectFromString(fis, DiagnosticData.class, "/xsd/DiagnosticData.xsd");
		assertNotNull(diagnosticData);

		CustomProcessExecutor executor = new CustomProcessExecutor();

		executor.setDiagnosticData(diagnosticData);
		executor.setValidationPolicy(loadPolicy());
		executor.setCurrentTime(diagnosticData.getValidationDate());

		Reports reports = executor.execute();
		assertNotNull(reports);
		String simpleReport = reports.getXmlSimpleReport();
		System.out.println(simpleReport);
		assertNotNull(simpleReport);
		String detailedReport = reports.getXmlDetailedReport();
		assertNotNull(detailedReport);
	}

	@Test
	public void defaultLocaleTest2() throws Exception {
		FileInputStream fis = new FileInputStream("src/test/resources/locale/dd.xml");
		DiagnosticData diagnosticData = getJAXBObjectFromString(fis, DiagnosticData.class, "/xsd/DiagnosticData.xsd");
		assertNotNull(diagnosticData);
		Locale.setDefault(new Locale("pl"));

		CustomProcessExecutor executor = new CustomProcessExecutor();
		executor.setDssLocale(new DSSLocale(DSSLocale.DEFAULT, "locale/testPolicyMessages"));

		executor.setDiagnosticData(diagnosticData);
		executor.setValidationPolicy(loadPolicy());
		executor.setCurrentTime(diagnosticData.getValidationDate());

		Reports reports = executor.execute();
		assertNotNull(reports);

		String simpleReport = reports.getXmlSimpleReport();
		assertNotNull(simpleReport);
		String detailedReport = reports.getXmlDetailedReport();
		assertNotNull(detailedReport);

		assertTrue(simpleReport.contains(DEFAULT_STRING));
		assertTrue(detailedReport.contains(DEFAULT_STRING));

	}

	@Test
	public void defaultLocaleTest3() throws Exception {
		FileInputStream fis = new FileInputStream("src/test/resources/locale/dd.xml");
		DiagnosticData diagnosticData = getJAXBObjectFromString(fis, DiagnosticData.class, "/xsd/DiagnosticData.xsd");
		assertNotNull(diagnosticData);
		// no "locale/testPolicyMessages_de.properties" file
		Locale.setDefault(new Locale("de"));

		CustomProcessExecutor executor = new CustomProcessExecutor();
		executor.setDssLocale(new DSSLocale(DSSLocale.DEFAULT, "locale/testPolicyMessages"));

		executor.setDiagnosticData(diagnosticData);
		executor.setValidationPolicy(loadPolicy());
		executor.setCurrentTime(diagnosticData.getValidationDate());

		Reports reports = executor.execute();
		assertNotNull(reports);

		String simpleReport = reports.getXmlSimpleReport();
		assertNotNull(simpleReport);
		String detailedReport = reports.getXmlDetailedReport();
		assertNotNull(detailedReport);

		assertTrue(simpleReport.contains(DEFAULT_STRING));
		assertTrue(detailedReport.contains(DEFAULT_STRING));

	}

	@Test
	public void plLocaleTest() throws Exception {
		FileInputStream fis = new FileInputStream("src/test/resources/locale/dd.xml");
		DiagnosticData diagnosticData = getJAXBObjectFromString(fis, DiagnosticData.class, "/xsd/DiagnosticData.xsd");
		assertNotNull(diagnosticData);

		CustomProcessExecutor executor = new CustomProcessExecutor();
		executor.setDssLocale(new DSSLocale("pl", "locale/testPolicyMessages"));

		executor.setDiagnosticData(diagnosticData);
		executor.setValidationPolicy(loadPolicy());
		executor.setCurrentTime(diagnosticData.getValidationDate());

		Reports reports = executor.execute();
		assertNotNull(reports);

		String simpleReport = reports.getXmlSimpleReport();
		assertNotNull(simpleReport);
		String detailedReport = reports.getXmlDetailedReport();
		assertNotNull(detailedReport);

		assertTrue(simpleReport.contains(PL_STRING));
		assertTrue(detailedReport.contains(PL_STRING));

	}

	@Test
	public void enLocaleTest() throws Exception {
		FileInputStream fis = new FileInputStream("src/test/resources/locale/dd.xml");
		DiagnosticData diagnosticData = getJAXBObjectFromString(fis, DiagnosticData.class, "/xsd/DiagnosticData.xsd");
		assertNotNull(diagnosticData);

		CustomProcessExecutor executor = new CustomProcessExecutor();
		executor.setDssLocale(new DSSLocale("en", "locale/testPolicyMessages"));

		executor.setDiagnosticData(diagnosticData);
		executor.setValidationPolicy(loadPolicy());
		executor.setCurrentTime(diagnosticData.getValidationDate());

		Reports reports = executor.execute();
		assertNotNull(reports);

		String simpleReport = reports.getXmlSimpleReport();
		assertNotNull(simpleReport);
		String detailedReport = reports.getXmlDetailedReport();
		assertNotNull(detailedReport);

		assertTrue(simpleReport.contains(EN_STRING));
		assertTrue(detailedReport.contains(EN_STRING));

	}

	@SuppressWarnings("unchecked")
	private <T extends Object> T getJAXBObjectFromString(InputStream is, Class<T> clazz, String xsd) throws Exception {
		JAXBContext context = JAXBContext.newInstance(clazz.getPackage().getName());
		Unmarshaller unmarshaller = context.createUnmarshaller();
		if (Utils.isStringNotEmpty(xsd)) {
			SchemaFactory sf = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			InputStream inputStream = this.getClass().getResourceAsStream(xsd);
			Source source = new StreamSource(inputStream);
			Schema schema = sf.newSchema(source);
			unmarshaller.setSchema(schema);
		}
		return (T) unmarshaller.unmarshal(is);
	}

	private EtsiValidationPolicy loadPolicy() throws Exception {
		FileInputStream policyFis = new FileInputStream("src/test/resources/locale/constraint.xml");
		ConstraintsParameters policyJaxB = getJAXBObjectFromString(policyFis, ConstraintsParameters.class);
		assertNotNull(policyJaxB);
		return new EtsiValidationPolicy(policyJaxB);
	}

	private <T extends Object> T getJAXBObjectFromString(InputStream is, Class<T> clazz) throws Exception {
		return getJAXBObjectFromString(is, clazz, null);
	}

}
