package gov.va.bip.origin.api;

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
	 * Contract for the "get sample info by PID" operation.
	 *
	 * @param sampleRequest the sample info request
	 * @return the sample info response
	 */
	public SampleResponse sampleByPid(@RequestBody final SampleRequest sampleRequest);
}
