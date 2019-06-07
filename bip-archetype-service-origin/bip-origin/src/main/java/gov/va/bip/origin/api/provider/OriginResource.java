package gov.va.bip.origin.api.provider;

import javax.annotation.PostConstruct;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.MediaType;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.framework.swagger.SwaggerResponseMessages;
import gov.va.bip.origin.api.OriginApi;
import gov.va.bip.origin.api.model.v1.SampleRequest;
import gov.va.bip.origin.api.model.v1.SampleResponse;
import io.swagger.annotations.ApiOperation;

/**
 * REST Service endpoint
 *
 * @author akulkarni
 */
@RestController
public class OriginResource implements OriginApi, SwaggerResponseMessages {

	/** Logger instance */
	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(OriginResource.class);

	/** The root path to this resource */
	public static final String URL_PREFIX = "/api/v1/origin";

	/** Data adapter between provider and service layers */
	@Autowired
	ServiceAdapter serviceAdapter;

	/** Properties for build information */
	@Autowired
	BuildProperties buildProperties;

	/**
	 * Log build information
	 */
	@PostConstruct
	public void postConstruct() {
		// Print build properties
		LOGGER.info(buildProperties.getName());
		LOGGER.info(buildProperties.getVersion());
		LOGGER.info(buildProperties.getArtifact());
		LOGGER.info(buildProperties.getGroup());
	}

	/**
	 * Search for Sample information by their participant ID.
	 * <p>
	 * CODING PRACTICE FOR RETURN TYPES - Platform auditing aspects support two return types.
	 * <ol>
	 * <li>An object that implements ProviderTransferObjectMarker, e.g.: SampleResponse
	 * <li>An object of type ResponseEntity&lt;ProviderTransferObjectMarker&gt;,
	 * e.g. a ResponseEntity that wraps some class that implements ProviderTransferObjectMarker.
	 * </ol>
	 * The auditing aspect won't be triggered if the return type in not one of the above.
	 *
	 * @param sampleRequest the sample info request
	 * @return the sample info response
	 */
	@Override
	@RequestMapping(value = URL_PREFIX + "/pid",
			produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.POST)
	@ApiOperation(value = "Retrieve sample information by PID from the Service .",
			notes = "Will return a sample info object based on search by PID.")
	public SampleResponse sampleByPid(@Valid @RequestBody final SampleRequest sampleRequest) {
		LOGGER.debug("sampleByPid() method invoked");

		SampleResponse providerResponse = serviceAdapter.sampleByPid(sampleRequest);
		// send provider response back to consumer
		LOGGER.debug("Returning providerResponse to consumer");
		return providerResponse;
	}

	/**
	 * Registers fields that should be allowed for data binding.
	 *
	 * @param binder
	 *            Spring-provided data binding context object.
	 */
	@InitBinder
	public void initBinder(final WebDataBinder binder) {
		binder.setAllowedFields(new String[] { "sampleInfo", "name", "participantId" });
	}
}
