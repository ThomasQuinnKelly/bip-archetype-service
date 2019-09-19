package gov.va.bip.origin.data;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import gov.va.bip.origin.data.sampledatasource1.entities.SampleData1;
import gov.va.bip.origin.data.sampledatasource1.repositories.SampleData1Repository;
import gov.va.bip.origin.data.sampledatasource2.entities.SampleData2;
import gov.va.bip.origin.data.sampledatasource2.repositories.SampleData2Repository;

@Component
public class SampleDataHelper {

	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(SampleDataHelper.class);

	@Autowired
	SampleData1Repository sampleData1Repo;

	@Autowired
	SampleData2Repository sampleData2Repo;

	/**
	 * Store sample data in sample-data-2 repository for a given pid.
	 *
	 * @param pid the pid
	 * @param sampleDatafield a field in database to be stored
	 */
	public void storeSampleData(final Long pid, final String sampleDatafield) {
		try {
			SampleData1 result = sampleData1Repo.findByPid(pid);
			if (result == null) {
				result = new SampleData1();
				result.setPid(pid);
			}
			result.setSampleDataField(sampleDatafield);
			sampleData1Repo.save(result);
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			throw e;
		}
	}

	/**
	 * Get the record corresponding to the pid in SAMPLE_DATA_2 table.
	 *
	 * @param pid the pid
	 * @return the data for pid
	 */
	public SampleData2 getSampleDataForPid(final Long pid) {
		try {
			SampleData2 result = sampleData2Repo.findByPid(pid);
			return result;
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			throw e;
		}
	}

}
