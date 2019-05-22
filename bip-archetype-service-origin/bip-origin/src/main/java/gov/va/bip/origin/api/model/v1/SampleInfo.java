package gov.va.bip.origin.api.model.v1;

import java.io.Serializable;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * This class represents the relevant subset of the data returned from the service layer.
 */
@ApiModel(description = "Model for data contained in the response from the Service")
public class SampleInfo implements Serializable {
	private static final long serialVersionUID = 5791227842810442936L;

	/** The name. */
	@ApiModelProperty(value = "The name", example = "JANE DOE")
	private String name;

	/** The participant id. */
	@ApiModelProperty(value = "The participant ID", example = "6666345")
	private Long participantId;

	/**
	 * Gets the name.
	 *
	 * @return The name
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
