package gov.va.bip.origin.client.ws;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import gov.va.bip.framework.exception.BipException;
import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.framework.messages.MessageSeverity;
import gov.va.bip.origin.messages.OriginMessageKeys;
import gov.va.bip.origin.model.SampleDomainRequest;
import gov.va.bip.origin.model.SampleDomainResponse;
import gov.va.bip.origin.model.SampleInfoDomain;
import gov.va.bip.origin.transform.impl.SampleByPidDomainToPartner;
import gov.va.bip.origin.transform.impl.SampleByPidPartnerToDomain;

/**
 * Make external calls to the partner using the partner client.
 * <p>
 * This Helper isolates references to partner clients. There should not be
 * references to partner client classes outside of this package.
 *
 * @author aburkholder
 */
@Component(PartnerHelper.BEAN_NAME)
public class PartnerHelper {
	public static final String BEAN_NAME = "partnerHelper";

	/** Logger */
	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(PartnerHelper.class);

	/** String to prepend messages for re-thrown exceptions */
	private static final String THROWSTR = "Rethrowing the following exception:  ";

	// /** WS client to run all intent to file operations via SOAP */
	// @Autowired
	// private SomeWsClient someWsClient;

	/** Transformer for domain-to-partner model transformation */
	private SampleByPidDomainToPartner sampleByPidD2P = new SampleByPidDomainToPartner();

	/** Transformer for partner-to-domain model transformation */
	private SampleByPidPartnerToDomain sampleByPidP2D = new SampleByPidPartnerToDomain();

	/**
	 * Make the partner call to find information by participant id.
	 *
	 * @param request the {@link SampleDomainRequest} from the domain
	 * @return SampleDomainResponse domain representation of the partner response
	 * @throws BipException
	 */
	public SampleDomainResponse sampleFindByPid(final SampleDomainRequest request) throws BipException {

		// transform from domain model request to partner model request
		// SomePartnerRequest partnerRequest = sampleByPidD2P.convert(request);

		// make a variable for the response from the partner
		// SomePartnerResponse partnerResponse = null;
		// make a variable for the response to send back to the service code
		SampleDomainResponse domainResponse = null;
		// // call the partner
		// try {
		// partnerResponse = someWsClient.getSomeClientMethod(partnerRequest);
		//
		// // transform from partner model response to domain model response
		// domainResponse = sampleByPidP2D.convert(partnerResponse);
		//
		// } catch (final BipException bipException) {
		// /*
		// * For this service, no useful work could be done without a successful call
		// * to the partner web service.
		// * So in this case, we throw a RuntimeException to abort execution and
		// * handle from BipRestGlobalExceptionHandler
		// */
		// // checked exception to be handled separately
		// String message = THROWSTR + bipException.getClass().getName() + ": " + bipException.getMessage();
		// LOGGER.error(message, bipException);
		// throw bipException;
		// } catch (final BipRuntimeException clientException) {
		// // any other exception can be caught and thrown as OriginServiceException for the circuit not to be opened
		// String message = THROWSTR + clientException.getClass().getName() + ": " + clientException.getMessage();
		// LOGGER.error(message, clientException);
		// throw new OriginServiceException(clientException.getMessageKey(), clientException.getSeverity(),
		// clientException.getStatus(), clientException.getParams());
		// } catch (final RuntimeException runtimeException) {
		// // RuntimeException can't be ignored as it's a candidate for circuit to be opened in Hystrix
		// String message = THROWSTR + runtimeException.getClass().getName() + ": " + runtimeException.getMessage();
		// LOGGER.error(message, runtimeException);
		// throw runtimeException;
		// }
		//
		// LOGGER.debug("Partner response: SampleFindByPtcpntIdResponse: {}",
		// partnerResponse == null ? "null" : ToStringBuilder.reflectionToString(partnerResponse));
		// LOGGER.debug("Domain response: SampleDomainResponse: {}",
		// domainResponse == null ? "null" : ToStringBuilder.reflectionToString(domainResponse));

		// For example purposes only (real response comes from the partner client as shown in commented code above)
		SampleInfoDomain sampleInfoDomain = new SampleInfoDomain();
		sampleInfoDomain.setName("JANE DOE");
		sampleInfoDomain.setParticipantId(request.getParticipantID());
		domainResponse = new SampleDomainResponse();
		domainResponse.setSampleInfo(sampleInfoDomain);
		domainResponse.addMessage(MessageSeverity.INFO, HttpStatus.OK,
				OriginMessageKeys.BIP_SAMPLE_SERVICE_IMPL_RESPONDED_WITH_MOCK_DATA, "");
		return domainResponse;
	}
}
