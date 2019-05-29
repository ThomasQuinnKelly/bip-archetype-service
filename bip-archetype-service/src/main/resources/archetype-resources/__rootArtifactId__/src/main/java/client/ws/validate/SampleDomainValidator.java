#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.client.ws.validate;

import gov.va.bip.framework.validation.Defense;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainRequest;

/**
 * Validation class used to validate request and response
 * objects to/from client invocation
 *
 * @author Vaanapalliv
 */
public class SampleDomainValidator {

	/**
	 * Validates {@link SampleDomainRequest} and {@link SampleDomainRequest${symbol_pound}getParticipantID()}
	 * for {@code null} and participantID is greater than zero.
	 *
	 * @param request
	 * @throws IllegalArgumentException if validation failed
	 */
	public static void validateSampleRequest(SampleDomainRequest request) {
		Defense.notNull(request, "SampleDomainRequest cannot be null");
		Defense.notNull(request.getParticipantID(), "SampleDomainRequest.participantID cannot be null");
		Defense.isTrue(request.getParticipantID() > 0, "SampleDomainRequest.participantID cannot be zero");
	}
}
