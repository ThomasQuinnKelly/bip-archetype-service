#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.api.provider;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.framework.validation.Defense;
import gov.va.bip.${artifactNameLowerCase}.${artifactName}Service;
import gov.va.bip.${artifactNameLowerCase}.api.model.v1.SampleRequest;
import gov.va.bip.${artifactNameLowerCase}.api.model.v1.SampleResponse;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainRequest;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainResponse;
import gov.va.bip.${artifactNameLowerCase}.transform.impl.SampleByPid_DomainToProvider;
import gov.va.bip.${artifactNameLowerCase}.transform.impl.SampleByPid_ProviderToDomain;

/**
 * An adapter between the provider layer api/model, and the services layer interface/model.
 *
 * @author aburkholder
 */
@Component
public class ServiceAdapter {
	/** Class logger */
	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(ServiceAdapter.class);

	/** Transform Provider (REST) request to Domain (service) request */
	private SampleByPid_ProviderToDomain sampleByPidProvider2Domain = new SampleByPid_ProviderToDomain();
	/** Transform Domain (service) response to Provider (REST) response */
	private SampleByPid_DomainToProvider sampleByPidDomain2Provider = new SampleByPid_DomainToProvider();

	/** The service layer API contract for processing sampleByPid() requests */
	@Autowired
	@Qualifier("${artifactNameUpperCase}_SERVICE_IMPL")
	private ${artifactName}Service ${artifactNameLowerCase}Service;

	/**
	 * Field defense validations.
	 */
	@PostConstruct
	public void postConstruct() {
		Defense.notNull(${artifactNameLowerCase}Service);
		Defense.notNull(sampleByPidProvider2Domain);
		Defense.notNull(sampleByPidDomain2Provider);
	}

	/**
	 * Adapt the sampleByPid(..) request mapping method to the equivalent service layer method.
	 *
	 * @param sampleRequest - the Provider layer request model object
	 * @return SampleResponse - the Provider layer response model object
	 */
	SampleResponse sampleByPid(final SampleRequest sampleRequest) {
		// transform provider request into domain request
		LOGGER.debug("Transforming from provider sampleRequest to sampleDomainRequest");
		SampleDomainRequest domainRequest = sampleByPidProvider2Domain.convert(sampleRequest);

		// get domain response from the service (domain) layer
		LOGGER.debug("Calling ${artifactNameLowerCase}Service.sampleFindByParticipantID");
		SampleDomainResponse domainResponse = ${artifactNameLowerCase}Service.sampleFindByParticipantID(domainRequest);

		// transform domain response into provider response
		LOGGER.debug("Transforming from domainResponse to providerResponse");
		SampleResponse providerResponse = sampleByPidDomain2Provider.convert(domainResponse);

		return providerResponse;
	}
}
