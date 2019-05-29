#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase};

import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainRequest;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainResponse;

/**
 * The contract interface for the domain (service) layer.
 *
 * @author aburkholder
 */
public interface ${artifactName}Service {
	/**
	 * Search for the sample info by their Participant ID.
	 *
	 * @param sampleDomainRequest A SampleDomainRequest instance
	 * @return A SampleDomainResponse instance
	 */
	SampleDomainResponse sampleFindByParticipantID(SampleDomainRequest sampleDomainRequest);
}
