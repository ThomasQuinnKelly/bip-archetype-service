#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.impl;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.netflix.hystrix.contrib.javanica.annotation.DefaultProperties;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;

import gov.va.bip.framework.cache.BipCacheUtil;
import gov.va.bip.framework.exception.BipException;
import gov.va.bip.framework.exception.BipRuntimeException;
import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.framework.messages.MessageKeys;
import gov.va.bip.framework.messages.MessageSeverity;
import gov.va.bip.framework.validation.Defense;
import gov.va.bip.${artifactNameLowerCase}.${artifactName}Service;
import gov.va.bip.${artifactNameLowerCase}.client.ws.PartnerHelper;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainRequest;
import gov.va.bip.${artifactNameLowerCase}.model.SampleDomainResponse;
import gov.va.bip.${artifactNameLowerCase}.utils.CacheConstants;
import gov.va.bip.${artifactNameLowerCase}.utils.HystrixCommandConstants;

/**
 * Implementation class for the ${artifactName} Service.
 * It is recommended to implement the hystrix circuit breaker pattern.
 * When there is a failure the fallback method is invoked and the response is
 * returned from the cache
 *
 * @author akulkarni
 */
@Service(value = ${artifactName}ServiceImpl.BEAN_NAME)
@Component
@Qualifier("${artifactNameUpperCase}_SERVICE_IMPL")
@RefreshScope
@DefaultProperties(groupKey = HystrixCommandConstants.${artifactNameUpperCase}_SERVICE_GROUP_KEY)
public class ${artifactName}ServiceImpl implements ${artifactName}Service {
	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(${artifactName}ServiceImpl.class);

	/** Bean name constant */
	public static final String BEAN_NAME = "${artifactNameLowerCase}ServiceImpl";

	/** The web service client helper. */
	@Autowired
	private PartnerHelper partnerHelper;

	@Autowired
	private CacheManager cacheManager;

	/**
	 * Viability checks before the application is put into service.
	 */
	@PostConstruct
	void postConstruct() {
		// Check for WS Client ref. Note that cacheManager is allowed to be null.
		Defense.notNull(partnerHelper,
				"Unable to proceed with partner service request. The partnerHelper must not be null.");
	}

	/**
	 * Implementation of the service (domain) layer API.
	 * <p>
	 * If graceful degredation is possible, add
	 * {@code fallbackMethod = "sampleFindByParticipantIDFallBack"}
	 * to the {@code @HystrixCommand}.
	 * <p>
	 * {@inheritDoc}
	 *
	 */
	@Override
	@CachePut(value = CacheConstants.CACHENAME_${artifactNameUpperCase}_SERVICE,
			key = "${symbol_pound}root.methodName + T(gov.va.bip.framework.cache.BipCacheUtil).createKey(${symbol_pound}sampleByPidDomainRequest.participantID)",
			unless = "T(gov.va.bip.framework.cache.BipCacheUtil).checkResultConditions(${symbol_pound}result)")
	/* If a fallback position is possible, add attribute to @HystrixCommand: fallback="fallbackMethodName" */
	@HystrixCommand(commandKey = "SampleFindByParticipantIDCommand",
			ignoreExceptions = { IllegalArgumentException.class, BipException.class, BipRuntimeException.class })
	public SampleDomainResponse sampleFindByParticipantID(final SampleDomainRequest sampleDomainRequest) {

		String cacheKey = "sampleFindByParticipantID" + BipCacheUtil.createKey(sampleDomainRequest.getParticipantID());

		// try from cache
		SampleDomainResponse response = null;
		try {
			Cache cache = null;
			if (cacheManager != null && (cache = cacheManager.getCache(CacheConstants.CACHENAME_${artifactNameUpperCase}_SERVICE)) != null
					&& cache.get(cacheKey) != null) {
				LOGGER.debug("sampleFindByParticipantID returning cached data");
				response = cache.get(cacheKey, SampleDomainResponse.class);
				return response;
			}
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
		}

		// try from partner
		if (response == null) {
			LOGGER.debug("sampleFindByParticipantID no cached data found");
			try {
				response = partnerHelper.sampleFindByPid(sampleDomainRequest);
			} catch (BipException | BipRuntimeException bipException) {
				SampleDomainResponse domainResponse = new SampleDomainResponse();
				// check exception..create domain model response
				domainResponse.addMessage(bipException.getSeverity(), bipException.getStatus(), bipException.getMessageKey(),
						bipException.getParams());
				return domainResponse;
			}
		}

		return response;
	}

	/**
	 * Support graceful degradation in a Hystrix command by adding a fallback method that Hystrix will call to obtain a
	 * default value or values in case the main command fails for {@link ${symbol_pound}sampleFindByParticipantID(SampleDomainRequest)}.
	 * <p>
	 * See {https://github.com/Netflix/Hystrix/wiki/How-To-Use${symbol_pound}fallback} for Hystrix Fallback usage
	 * <p>
	 * Hystrix doesn't REQUIRE you to set this method. However, if it is possible to degrade gracefully
	 * - perhaps by returning static data, or performing some other process - the degraded process should
	 * be performed in the fallback method. In order to enable a fallback such as this, on the main method,
	 * add to its {@code @HystrixCommand} the {@code fallbackMethod} attribute. So for
	 * {@link ${symbol_pound}sampleFindByParticipantID(SampleDomainRequest)}
	 * you would add the attribute to its {@code @HystrixCommand}:<br/>
	 *
	 * <pre>
	 * fallbackMethod = "sampleFindByParticipantIDFallBack"
	 * </pre>
	 *
	 * <b>Note that exceptions should not be thrown from any fallback method.</b>
	 * It will "confuse" Hystrix and cause it to throw an HystrixRuntimeException.
	 * <p>
	 *
	 * @param sampleDomainRequest The request from the Java Service.
	 * @param throwable the throwable
	 * @return A JAXB element for the WS request
	 */
	@HystrixCommand(commandKey = "SampleFindByParticipantIDFallBackCommand")
	public SampleDomainResponse sampleFindByParticipantIDFallBack(final SampleDomainRequest sampleDomainRequest,
			final Throwable throwable) {
		LOGGER.info("sampleFindByParticipantIDFallBack has been activated");

		final SampleDomainResponse response = new SampleDomainResponse();
		response.setDoNotCacheResponse(true);

		if (throwable != null) {
			LOGGER.debug(ReflectionToStringBuilder.toString(throwable, null, true, true, Throwable.class));
			response.addMessage(MessageSeverity.WARN, HttpStatus.OK, MessageKeys.BIP_GLOBAL_GENERAL_EXCEPTION,
					throwable.getClass().getSimpleName(), throwable.getLocalizedMessage());
		} else {
			LOGGER.error(
					"smapleFindByParticipantIDFallBack No Throwable Exception. Just Raise Runtime Exception {}",
					sampleDomainRequest);
			response.addMessage(MessageSeverity.WARN, HttpStatus.OK, MessageKeys.WARN_KEY,
					"There was a problem processing your request.");
		}
		return response;
	}
}
