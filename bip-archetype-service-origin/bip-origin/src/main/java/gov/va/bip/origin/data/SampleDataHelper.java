package gov.va.bip.origin.data;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.origin.data.entities.SampleData;
import gov.va.bip.origin.data.repositories.SampleDataRepository;

@Component
public class SampleDataHelper {

	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(SampleDataHelper.class);

	@Autowired
	SampleDataRepository sampleDataRepository;

	/**
	 * Store sample data in person repository for a given pid.
	 *
	 * @param pid the pid
	 * @param sampleDatafield a field in database to be stored
	 */
	public void storeMetadata(final Long pid, final String sampleDatafield) {
		try {
			SampleData result = sampleDataRepository.findByPid(pid);
			if (result == null) {
				result = new SampleData();
				result.setPid(pid);
			}
			result.setSampleDataField(sampleDatafield);
			sampleDataRepository.save(result);
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			throw e;
		}
	}

	/**
	 * Get the record corresponding to the pid in SAMPLE_DATA table.
	 *
	 * @param pid the pid
	 * @return the data for pid
	 */
	public SampleData getDataForPid(final Long pid) {
		try {
			SampleData result = sampleDataRepository.findByPid(pid);
			return result;
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			throw e;
		}
	}

}
