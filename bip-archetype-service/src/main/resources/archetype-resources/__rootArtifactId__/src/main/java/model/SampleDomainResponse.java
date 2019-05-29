#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.model;

import gov.va.bip.framework.service.DomainResponse;

/**
 * This domain model represents a response from processing
 * a request for SampleInfoDomain by participant ID.
 * <p>
 * The domain service implementation returns this response to the provider.
 */
public class SampleDomainResponse extends DomainResponse {

	/** Id for serialization. */
	private static final long serialVersionUID = 8470614006372046829L;

	/** A SampleInfoDomain instance. */
	private SampleInfoDomain sampleInfoDomain;

	/**
	 * Gets the sample info.
	 *
	 * @return A SampleInfoDomain instance
	 */
	public final SampleInfoDomain getSampleInfo() {
		return sampleInfoDomain;
	}

	/**
	 * Sets the sample info.
	 *
	 * @param sampleInfoDomain A SampleInfoDomain instance
	 */
	public final void setSampleInfo(final SampleInfoDomain sampleInfoDomain) {
		this.sampleInfoDomain = sampleInfoDomain;
	}
}
