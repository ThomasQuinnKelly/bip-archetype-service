#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.api.model.v1;

import gov.va.bip.framework.rest.provider.ProviderResponse;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * A class to represent the data contained in the response
 * from the Service.
 *
 */
@ApiModel(description = "Model for the response from the Service")
public class SampleResponse extends ProviderResponse {
	private static final long serialVersionUID = -3964574323969408832L;

	/** A SampleInfoDomain instance. */
	@ApiModelProperty(value = "The object representing the sample information")
	private SampleInfo sampleInfo;

	/**
	 * Gets the sample info.
	 *
	 * @return A SampleInfoDomain instance
	 */
	public final SampleInfo getSampleInfo() {
		return sampleInfo;
	}

	/**
	 * Sets the sample info.
	 *
	 * @param sampleInfo A SampleInfoDomain instance
	 */
	public final void setSampleInfo(final SampleInfo sampleInfo) {
		this.sampleInfo = sampleInfo;
	}
}
