package gov.va.bip.origin.model;

import java.io.Serializable;

/**
 * This domain model represents the relevant subset of the data returned from the database layer for use in the person business layer,
 * as required by the REST "origin" controller.
 */
public class SampleDataDomain implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/** The sample Data Field present in the SAMPLE_DATA table. */
	private String sampleDataField;

	public String getSampleDatafield() {
		return sampleDataField;
	}

	public void setSampleDatafield(final String sampleDataField) {
		this.sampleDataField = sampleDataField;
	}

}
