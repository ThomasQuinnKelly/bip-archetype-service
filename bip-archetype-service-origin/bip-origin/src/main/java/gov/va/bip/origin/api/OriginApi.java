package gov.va.bip.origin.api;

import org.springframework.boot.actuate.health.Health;
import org.springframework.web.bind.annotation.RequestBody;

import gov.va.bip.origin.api.model.v1.SampleRequest;
import gov.va.bip.origin.api.model.v1.SampleResponse;

/**
 * The contract for the Origin endpoint.
 *
 * @author aburkholder
 */
public interface OriginApi {

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
