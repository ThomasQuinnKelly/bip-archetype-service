package gov.va.bip.origin.config;

import javax.sql.DataSource;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.springframework.boot.autoconfigure.liquibase.LiquibaseProperties;
import gov.va.bip.framework.log.BipLogger;
import gov.va.bip.framework.log.BipLoggerFactory;
import liquibase.integration.spring.SpringLiquibase;

/**
 * Base class for SampleDatasource* classes
 *
 * @author aburkholder
 */
public abstract class OriginDatasourceBase {

	private static final BipLogger LOGGER = BipLoggerFactory.getLogger(OriginDatasourceBase.class);

	/**
	 * Set Liquibase object properties using the provided datasource and properties.
	 * <p>
	 * Does <b>NOT</b> use or set the following properties:
	 * <ul>
	 * <li>CheckChangeLogLocation
	 * <li>IgnoreClasspathPrefix
	 * <li>Tag
	 * </ul>
	 *
	 * @param dataSource the datasource to use
	 * @param properties the properties to use
	 * @return SpringLiquibase the liquibase object
	 */
	SpringLiquibase springLiquibase(final DataSource dataSource, final LiquibaseProperties properties) {
		SpringLiquibase liquibase = new SpringLiquibase();
		liquibase.setDataSource(dataSource);
		liquibase.setChangeLog(properties.getChangeLog());
		liquibase.setContexts(properties.getContexts());
		liquibase.setDefaultSchema(properties.getDefaultSchema());
		liquibase.setDropFirst(properties.isDropFirst());
		liquibase.setShouldRun(properties.isEnabled());
		liquibase.setLabels(properties.getLabels());
		liquibase.setChangeLogParameters(properties.getParameters());
		liquibase.setRollbackFile(properties.getRollbackFile());
		liquibase.setDatabaseChangeLogLockTable(properties.getDatabaseChangeLogLockTable());
		liquibase.setDatabaseChangeLogTable(properties.getDatabaseChangeLogTable());
		liquibase.setLiquibaseSchema(properties.getLiquibaseSchema());
		liquibase.setLiquibaseTablespace(properties.getLiquibaseTablespace());
		liquibase.setTestRollbackOnUpdate(properties.isTestRollbackOnUpdate());
		LOGGER.debug("Liquibase Properties: {}", ReflectionToStringBuilder.toString(liquibase));
		return liquibase;
	}
}
