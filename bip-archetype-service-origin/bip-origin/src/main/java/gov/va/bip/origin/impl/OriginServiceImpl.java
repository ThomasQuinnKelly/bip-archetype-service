package gov.va.bip.origin.impl;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.netflix.hystrix.contrib.javanica.annotation.DefaultProperties;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;

import gov.va.bip.framework.cache.BipCacheUtil;
import gov.va.bip.framework.exception.BipException;
import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.framework.validation.Defense;
import gov.va.bip.origin.OriginService;
import gov.va.bip.origin.data.SampleDataHelper;
import gov.va.bip.origin.data.entities.SampleData;
import gov.va.bip.origin.model.SampleDomainRequest;
import gov.va.bip.origin.model.SampleDomainResponse;
import gov.va.bip.origin.model.SampleInfoDomain;
import gov.va.bip.origin.utils.CacheConstants;
import gov.va.bip.origin.utils.HystrixCommandConstants;

/**
 * Implementation class for the Origin Service.
 * It is recommended to implement the hystrix circuit breaker pattern.
 * When there is a failure the fallback method is invoked and the response is
 * returned from the cache
 *
 * @author akulkarni
 */
@Service(value = OriginServiceImpl.BEAN_NAME)
@Component
@Qualifier("ORIGIN_SERVICE_IMPL")
@RefreshScope
@DefaultProperties(groupKey = HystrixCommandConstants.ORIGIN_SERVICE_GROUP_KEY)
public class OriginServiceImpl implements OriginService {
	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(OriginServiceImpl.class);

	/** Bean name constant */
	public static final String BEAN_NAME = "originServiceImpl";

	@Autowired
	private CacheManager cacheManager;

	/** The origin web service database operations helper. */
	@Autowired
	private SampleDataHelper sampleDatabaseHelper;

	/**
	 * Viability checks before the application is put into service.
	 */
	@PostConstruct
	void postConstruct() {
		// Check for WS Client ref. Note that cacheManager is allowed to be null.
		Defense.notNull(sampleDatabaseHelper,
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
	@CachePut(value = CacheConstants.CACHENAME_ORIGIN_SERVICE,
	key = "#root.methodName + T(gov.va.bip.framework.cache.BipCacheUtil).createKey(#sampleDomainRequest.participantID)",
	unless = "T(gov.va.bip.framework.cache.BipCacheUtil).checkResultConditions(#result)")
	/* If a fallback position is possible, add attribute to @HystrixCommand: fallback="fallbackMethodName" */
	@HystrixCommand(commandKey = "SampleFindByParticipantIDCommand",
	ignoreExceptions = { IllegalArgumentException.class, BipException.class})
	public SampleDomainResponse sampleFindByParticipantID(final SampleDomainRequest sampleDomainRequest) {

		String cacheKey = "sampleFindByParticipantID" + BipCacheUtil.createKey(sampleDomainRequest.getParticipantID());

		// try from cache
		SampleDomainResponse response = null;
		try {
			Cache cache = null;
			if ((cacheManager != null) && ((cache = cacheManager.getCache(CacheConstants.CACHENAME_ORIGIN_SERVICE)) != null)
					&& (cache.get(cacheKey) != null)) {
				LOGGER.debug("sampleFindByParticipantID returning cached data");
				return cache.get(cacheKey, SampleDomainResponse.class);
			}
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
		}

		// try from partner
		LOGGER.debug("sampleFindByParticipantID no cached data found");
		SampleData data = null;
		// try {
		data = sampleDatabaseHelper.getDataForPid(sampleDomainRequest.getParticipantID());
		if (data == null) {
			return null;
		}
		new SampleDomainResponse();
		new SampleInfoDomain();

		return response;
	}	

}