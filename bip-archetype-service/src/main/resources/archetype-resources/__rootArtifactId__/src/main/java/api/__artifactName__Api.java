#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.api;

import org.springframework.boot.actuate.health.Health;
import org.springframework.web.bind.annotation.RequestBody;

import gov.va.bip.${artifactNameLowerCase}.api.model.v1.SampleRequest;
import gov.va.bip.${artifactNameLowerCase}.api.model.v1.SampleResponse;

/**
 * The contract for the ${artifactName} endpoint.
 *
 * @author aburkholder
 */
public interface ${artifactName}Api {

	/**
	 * Contract for the {@link Health} operation.
	 *
	 * @return Health
	 */
	public Health health();

	/**
	 * Contract for the "get sample info by PID" operation.
	 *
	 * @param sampleRequest the sample info request
	 * @return the sample info response
	 */
	public SampleResponse sampleByPid(@RequestBody final SampleRequest sampleRequest);
}
