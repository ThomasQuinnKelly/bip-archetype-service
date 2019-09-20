package gov.va.bip.origin.model;

import gov.va.bip.framework.service.DomainResponse;

/**
 * This domain model represents a response from processing a request for getSampleDataForPid.
 * <p>
 * The domain service implementation returns this response to the provider.
 */
public class SampleDataDomainResponse extends DomainResponse {

	/** Id for serialization. */
	private static final long serialVersionUID = 1L;

	/** A SampleDataDomain instance. */
	private SampleDataDomain sampleDataDomain;

	/**
	 * Gets the sample data
	 *
	 * @return A SampleDataDomain instance
	 */
	public final SampleDataDomain getSampleDataDomain() {
		return sampleDataDomain;
	}

	/**
	 * Sets the Sample data object for the provider
	 *
	 * @param sampleDataDomain A sampleDataDomain instance
	 */
	public final void setSampleDataDomain(final SampleDataDomain sampleDataDomain) {
		this.sampleDataDomain = sampleDataDomain;
	}
}
