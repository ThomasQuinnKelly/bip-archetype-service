package gov.va.bip.origin.data.sampledatasource1.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import gov.va.bip.origin.data.sampledatasource1.entities.SampleData1;

/**
 * Repository Class to handle database access operation to the SAMPLE_DATA_1 table associated with the SampleData1 POJO
 *
 */
@Repository
public interface SampleData1Repository extends JpaRepository<SampleData1, Long> {

	/**
	 * Retrieve a SampleData1 based on the pid.
	 *
	 * @param pid the pid
	 * @return SampleData1
	 */
	public SampleData1 findByPid(Long pid);

}
