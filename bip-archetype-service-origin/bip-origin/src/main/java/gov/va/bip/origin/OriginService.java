package gov.va.bip.origin;

import gov.va.bip.origin.model.SampleDomainRequest;
import gov.va.bip.origin.model.SampleDomainResponse;

/**
 * The contract interface for the domain (service) layer.
 *
 * @author aburkholder
 */
public interface OriginService {
	/**
	 * Search for the sample info by their Participant ID.
	 *
	 * @param sampleDomainRequest A SampleDomainRequest instance
	 * @return A SampleDomainResponse instance
	 */
	SampleDomainResponse sampleFindByParticipantID(SampleDomainRequest sampleDomainRequest);
}
