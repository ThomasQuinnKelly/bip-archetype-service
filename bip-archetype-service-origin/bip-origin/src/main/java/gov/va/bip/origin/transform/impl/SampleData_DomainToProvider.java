package gov.va.bip.origin.transform.impl;

import gov.va.bip.framework.transfer.transform.AbstractDomainToProvider;
import gov.va.bip.origin.api.model.v1.SampleInfo;
import gov.va.bip.origin.api.model.v1.SampleResponse;
import gov.va.bip.origin.model.SampleDataDomainResponse;
import gov.va.bip.origin.model.SampleDomainResponse;

/**
 * Transform a service Domain {@link SampleDataDomainResponse} into a REST Provider {@link SampleDataResponse} object.
 *
 * @author aburkholder
 */
public class SampleData_DomainToProvider
extends AbstractDomainToProvider<SampleDomainResponse, gov.va.bip.origin.api.model.v1.SampleResponse> {

	/**
	 * Transform a service Domain {@link SampleDomainResponse} into a REST Provider {@link SampleResponse} object. <br/>
	 * <b>Member objects inside the returned object may be {@code null}.</b>
	 * <p>
	 * {@inheritDoc AbstractDomainToProvider}
	 */
	@Override
	public gov.va.bip.origin.api.model.v1.SampleResponse convert(final SampleDomainResponse domainObject) {
		SampleResponse providerObject = new SampleResponse();

		// add data
		SampleInfo providerData = new SampleInfo();
		if ((domainObject != null) && (domainObject.getSampleInfo() != null)) {
			providerData.setSampleDatafield(domainObject.getSampleInfo().getName());
		}
		providerObject.setSampleInfo(providerData);
		// add messages
		if ((domainObject != null) && (domainObject.getMessages() != null) && !domainObject.getMessages().isEmpty()) {
			for (gov.va.bip.framework.messages.ServiceMessage domainMsg : domainObject.getMessages()) {
				providerObject.addMessage(domainMsg.getSeverity(), domainMsg.getKey(), domainMsg.getText(), domainMsg.getHttpStatus());
			}
		}

		return providerObject;
	}
}
