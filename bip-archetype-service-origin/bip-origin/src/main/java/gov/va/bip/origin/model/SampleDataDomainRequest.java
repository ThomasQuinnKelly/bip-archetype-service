package gov.va.bip.origin.model;

import gov.va.bip.framework.service.DomainRequest;

/**
 * This domain model represents a request for SampleDataDomain by participant ID.
 * <p>
 * The domain service implementation uses this request to derive the appropriate response.
 */
public class SampleDataDomainRequest extends DomainRequest {
	public static final String MODEL_NAME = SampleDataDomainRequest.class.getSimpleName();

	/** version id. */
	private static final long serialVersionUID = 1L;

	/** A String representing a participant ID. */
	private Long participantID;

	/**
	 * Gets the participantId.
	 *
	 * @return the participantID
	 */
	public final Long getParticipantID() {
		return this.participantID;
	}

	/**
	 * Sets the participantId.
	 *
	 * @param participantID the participantID
	 */
	public final void setParticipantID(final Long participantID) {
		this.participantID = participantID;
	}
}
