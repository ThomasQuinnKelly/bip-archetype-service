#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase}.model;

import java.io.Serializable;

/**
 * This domain model represents the relevant subset of the data
 * returned from the partner client,
 * for use in the business layer,
 * as required by the REST controller.
 */
public class SampleInfoDomain implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/** The sample name. */
	private String name;

	/** the sample participant id. */
	private Long participantId;

	/**
	 * Gets the name.
	 *
	 * @return The first name
	 */
	public final String getName() {
		return name;
	}

	/**
	 * Sets the name.
	 *
	 * @param name The name
	 */
	public final void setName(final String name) {
		this.name = name;
	}

	/**
	 * Gets the participant id.
	 *
	 * @return The participant Id
	 */
	public final Long getParticipantId() {
		return participantId;
	}

	/**
	 * Sets the participant id.
	 *
	 * @param participantId The participant Id
	 */
	public final void setParticipantId(final Long participantId) {
		this.participantId = participantId;
	}
}
