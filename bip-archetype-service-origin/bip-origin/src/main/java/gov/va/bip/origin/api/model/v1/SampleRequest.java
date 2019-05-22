package gov.va.bip.origin.api.model.v1;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import gov.va.bip.framework.transfer.ProviderTransferObjectMarker;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * A class to represent a request for SampleInfoDomain from the Service.
 *
 */
@ApiModel(description = "Model for data to request SampleInfoDomain from the Service")
@NotNull(message = "{bip.origin.sample.request.NotNull}")
public class SampleRequest implements ProviderTransferObjectMarker {
	public static final String MODEL_NAME = SampleRequest.class.getSimpleName();

	/** A String representing a social security number. */
	@ApiModelProperty(value = "The Participant ID for whom to retrieve data", required = true,
			example = "6666345")
	@NotNull(message = "{bip.origin.sample.request.pid.NotNull}")
	@Min(value = 1, message = "{bip.origin.sample.request.pid.Min}")
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
