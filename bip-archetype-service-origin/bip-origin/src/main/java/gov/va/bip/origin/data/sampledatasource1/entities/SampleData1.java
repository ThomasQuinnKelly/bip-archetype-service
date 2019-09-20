package gov.va.bip.origin.data.sampledatasource1.entities;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import org.hibernate.annotations.Table;

/**
 * SampleData1 POJO mapped to the records in the SAMPLE_DATA_1 table in database
 *
 */
@Entity(name = "SampleData1")
@Table(appliesTo = "SampleData1")
@SequenceGenerator(name = "seq", initialValue = 10, allocationSize = 100)
public class SampleData1 implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
	private long id;

	private long pid;

	@Column(name = "sample_data_field")
	private String sampleDataField;

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
