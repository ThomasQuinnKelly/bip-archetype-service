#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.service.steps;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import gov.va.bip.framework.test.rest.BaseStepDefHandler;
import gov.va.bip.framework.test.util.JsonUtil;

/**
 * The health feature and scenario implementations for the API needs are specified here.
 * <p>
 * For more details please Read the <a
 * href="https://github.com/department-of-veterans-affairs/bip-reference-person/blob/master/docs/referenceperson-intest.md">Integration
 * Testing Guide</a>
 */
public class Health {

	final static Logger LOGGER = LoggerFactory.getLogger(Health.class);
	private BaseStepDefHandler handler = null;

	public Health(BaseStepDefHandler handler) {
		this.handler = handler;
	}

	@Before({})
	public void setUpREST() {
		handler.initREST();
	}

	@Given("^the claimant is not a ${symbol_escape}"([^${symbol_escape}"]*)${symbol_escape}"${symbol_dollar}")
	public void setHeader(String users) throws Throwable {
		handler.setHeader(users);
	}

	@When("^client request health info ${symbol_escape}"([^${symbol_escape}"]*)${symbol_escape}"${symbol_dollar}")
	public void makingGetRequest(final String strURL) throws Throwable {
		String baseUrl = handler.getRestConfig().getProperty("baseURL", true);
		handler.invokeAPIUsingGet(baseUrl + strURL);
	}

	@And("verify health service status is UP and details of Service REST Provider Up and Running")
	public void get${artifactName}HealthMessageValidation() {
		String status = JsonUtil.getString(handler.getStrResponse(), "status");
		String details = JsonUtil.getString(handler.getStrResponse(),
				"['details'].['${artifactName} Service REST Endpoint']");
		assertThat(status, equalTo("UP"));
		assertThat(details, equalTo("${artifactName} Service REST Provider Up and Running!"));
	}

	@After({})
	public void cleanUp(Scenario scenario) {
		handler.postProcess(scenario);

	}
}
