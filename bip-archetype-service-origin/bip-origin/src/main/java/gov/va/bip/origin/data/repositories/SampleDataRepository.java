package gov.va.bip.origin.data.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import gov.va.bip.origin.data.entities.SampleData;

/**
 * Repository Class to handle database access operation to the SAMPLE_DATA table associated with the PersonDocs POJO
 *
 */
@Repository
public interface SampleDataRepository extends JpaRepository<SampleData, Long> {

	/**
	 * Retrieve a SampleData based on the pid.
	 *
	 * @param pid the pid
	 * @return SampleData
	 */
	public SampleData findByPid(Long pid);

}
