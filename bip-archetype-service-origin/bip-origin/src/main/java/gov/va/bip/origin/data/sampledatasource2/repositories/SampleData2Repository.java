package gov.va.bip.origin.data.sampledatasource2.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import gov.va.bip.origin.data.sampledatasource2.entities.SampleData2;

/**
 * Repository Class to handle database access operation to the SAMPLE_DATA_2 table associated with the SampleData2 POJO
 *
 */
@Repository
public interface SampleData2Repository extends JpaRepository<SampleData2, Long> {

	/**
	 * Retrieve a SampleData1 based on the pid.
	 *
	 * @param pid the pid
	 * @return SampleData1
	 */
	public SampleData2 findByPid(Long pid);

}
