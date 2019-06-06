package gov.va.bip.origin.client.ws;

import org.springframework.stereotype.Component;

import gov.va.bip.framework.exception.BipException;
import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.origin.model.SampleDomainRequest;
import gov.va.bip.origin.model.SampleDomainResponse;
import gov.va.bip.origin.model.SampleInfoDomain;
import gov.va.bip.origin.transform.impl.SampleByPid_DomainToPartner;
import gov.va.bip.origin.transform.impl.SampleByPid_PartnerToDomain;

/**
 * Make external calls to the partner using the partner client.
 * <p>
 * This Helper isolates references to partner clients. There should not be
 * references to partner client classes outside of this class.
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

//	/** WS client to run all intent to file operations via SOAP */
//	@Autowired
//	private SomeWsClient someWsClient;

	/** Transformer for domain-to-partner model transformation */
	private SampleByPid_DomainToPartner sampleByPidD2P = new SampleByPid_DomainToPartner();

	/** Transformer for partner-to-domain model transformation */
	private SampleByPid_PartnerToDomain sampleByPidP2D = new SampleByPid_PartnerToDomain();

	/**
	 * Make the partner call to find information by participant id.
	 *
	 * @param request the {@link SampleDomainRequest} from the domain
	 * @return SampleDomainResponse domain representation of the partner response
	 * @throws BipException
	 */
	public SampleDomainResponse sampleFindByPid(SampleDomainRequest request) throws BipException {

		// transform from domain model request to partner model request
//		SomePartnerRequest partnerRequest = sampleByPidD2P.convert(request);

//		SomePartnerResponse partnerResponse = null;
		SampleDomainResponse domainResponse = null;
//		// call the partner
//		try {
//			partnerResponse = someWsClient.callClientMethod(partnerRequest);
//
//			// transform from partner model response to domain model response
//			domainResponse = sampleByPidP2D.convert(partnerResponse);
//
//		} catch (final BipException bipException) {
//			/*
//			 * For this service, no useful work could be done without a successful call
//			 * to the partner web service.
//			 * So in this case, we throw a RuntimeException to abort execution and
//			 * handle from BipRestGlobalExceptionHandler
//			 */
//			// checked exception to be handled separately
//			String message = THROWSTR + bipException.getClass().getName() + ": " + bipException.getMessage();
//			LOGGER.error(message, bipException);
//			throw bipException;
//		} catch (final BipRuntimeException clientException) {
//			// any other exception can be caught and thrown as OriginServiceException for the circuit not to be opened
//			String message = THROWSTR + clientException.getClass().getName() + ": " + clientException.getMessage();
//			LOGGER.error(message, clientException);
//			throw new OriginServiceException(clientException.getMessageKey(), clientException.getSeverity(),
//					clientException.getStatus(), clientException.getParams());
//		} catch (final RuntimeException runtimeException) {
//			// RuntimeException can't be ignored as it's a candidate for circuit to be opened in Hystrix
//			String message = THROWSTR + runtimeException.getClass().getName() + ": " + runtimeException.getMessage();
//			LOGGER.error(message, runtimeException);
//			throw runtimeException;
//		}
//
//		LOGGER.debug("Partner response: SampleFindByPtcpntIdResponse: {}",
//				partnerResponse == null ? "null" : ToStringBuilder.reflectionToString(partnerResponse));
//		LOGGER.debug("Domain response: SampleDomainResponse: {}",
//				domainResponse == null ? "null" : ToStringBuilder.reflectionToString(domainResponse));

		// For example purposes only (real response comes from the partner client)
		SampleInfoDomain sampleInfoDomain = new SampleInfoDomain();
		sampleInfoDomain.setName("JANE DOE");
		sampleInfoDomain.setParticipantId(6666345l);
		domainResponse = new SampleDomainResponse();
		domainResponse.setSampleInfo(sampleInfoDomain);

		return domainResponse;
	}
}
