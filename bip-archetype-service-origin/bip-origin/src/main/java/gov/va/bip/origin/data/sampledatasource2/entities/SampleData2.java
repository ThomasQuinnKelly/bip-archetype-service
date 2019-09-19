package gov.va.bip.origin.data.sampledatasource2.entities;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

/**
 * SampleData2 POJO mapped to the records in the SAMPLE_DATA_2 table in database
 *
 */
@Entity
@SequenceGenerator(name = "seq", initialValue = 10, allocationSize = 100)
public class SampleData2 implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
	private long id;

	private long pid;

	public long getId() {
		return id;
	}

	public void setId(final long id) {
		this.id = id;
	}

	public long getPid() {
		return pid;
	}

	public void setPid(final long pid) {
		this.pid = pid;
	}

	private String sampleDataField;

	public String getSampleDatafield() {
		return sampleDataField;
	}

	public void setSampleDataField(final String sampleDatafield) {
		this.sampleDataField = sampleDatafield;
	}

	@Override
	public String toString() {
		return "ClassPojo [id = " + id + ", pid = " + pid + ", sampleDatafield = " + sampleDataField + "]";
	}
}
