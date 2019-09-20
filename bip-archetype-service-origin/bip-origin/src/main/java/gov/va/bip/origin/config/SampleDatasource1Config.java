package gov.va.bip.origin.config;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.autoconfigure.liquibase.LiquibaseProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariDataSource;

import liquibase.integration.spring.SpringLiquibase;

/**
 * Configuration for the SampleDatasource1, entity manager factory, transaction manager, and liquibase beans.
 *
 * @author aburkholder
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(entityManagerFactoryRef = "sampleDatasource1EntityManagerFactory", transactionManagerRef = "sampleDatasource1TransactionManager",
// jpa repo base package
basePackages = "gov.va.bip.origin.data.sampledatasource1")
public class SampleDatasource1Config extends OriginDatasourceBase {

	private static final String SAMPLE_DATASOURCE1_JPA_PREFIX = "db.jpa.sampledatasource1";
	private static final String SAMPLE_DATASOURCE1_DATASOURCE_PREFIX = "db.datasource.sampledatasource1";
	private static final String SAMPLE_DATASOURCE1_HIKARI_DATASOURCE_PREFIX = "db.datasource.sampledatasource1.hikari";
	private static final String SAMPLE_DATASOURCE1_LIQUIBASE_PROPERTY_PREFIX = "db.liquibase.sampledatasource1";
	private static final String SAMPLE_DATASOURCE1_PERSISTENCE_UNIT = "sampleDatasource1";

	private static final String[] SAMPLE_DATASOURCE1_ENTITIES_PACKAGES = { "gov.va.bip.origin.data.sampledatasource1.entities" };

	/**
	 * Properties for the datasource and to populate liquibase config.
	 *
	 * @return DataSourceProperties
	 */
	@Bean
	@Primary
	@ConfigurationProperties(SAMPLE_DATASOURCE1_DATASOURCE_PREFIX)
	public DataSourceProperties sampleDatasource1Properties() {
		return new DataSourceProperties();
	}

	/**
	 * SampleDatasource1 for a sample database1, via hikari datasource pool.
	 * <p>
	 * Application yaml configures this datasource with db.datasource.sampledatasource1.** properties.
	 * <p>
	 * This datasource puts all values into the hikari config, but does not populate the "normal" datasource properties (url, user,
	 * pass). These values are manually added back so that liquibase can be initiated correctly.
	 *
	 * @return DataSource - the datasource called sampleDatasource1
	 */
	@Primary
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE1_HIKARI_DATASOURCE_PREFIX)
	public HikariDataSource sampleDatasource1() {
		return sampleDatasource1Properties().initializeDataSourceBuilder().type(HikariDataSource.class).build();
	}

	/**
	 * Entity Manager for sampleDatasource1 entities.
	 *
	 * @param builder a builder for entity manager factory
	 * @param dataSource must be the "sampleDatasource1" bean
	 * @return LocalContainerEntityManagerFactoryBean entity manager for sampleDatasource1
	 */
	@Primary
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE1_JPA_PREFIX)
	public LocalContainerEntityManagerFactoryBean sampleDatasource1EntityManagerFactory(final EntityManagerFactoryBuilder builder,
			@Qualifier("sampleDatasource1") final DataSource dataSource) {
		return builder.dataSource(dataSource).packages(SAMPLE_DATASOURCE1_ENTITIES_PACKAGES)
				.persistenceUnit(SAMPLE_DATASOURCE1_PERSISTENCE_UNIT)
				.build();
	}

	/**
	 * Transaction Manager for sampleDatasource1 entities.
	 *
	 * @param entityManagerFactory must be the "sampleDatasource1EntityManagerFactory" bean
	 * @return PlatformTransactionManager transaction manager for sampleDatasource1EntityManagerFactory
	 */
	@Primary
	@Bean
	public PlatformTransactionManager
	sampleDatasource1TransactionManager(
			@Qualifier("sampleDatasource1EntityManagerFactory") final EntityManagerFactory entityManagerFactory) {
		return new JpaTransactionManager(entityManagerFactory);
	}

	/**
	 * Bean for liquibase properties.
	 *
	 * @return LiquibaseProperties properties for liquibase
	 */
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE1_LIQUIBASE_PROPERTY_PREFIX)
	public LiquibaseProperties sampleDatasource1LiquibaseProperties() {
		return new LiquibaseProperties();
	}

	/**
	 * The liquibase object configured for the datasource with the liquibase properties.
	 *
	 * @return SpringLiquibase
	 */
	@Bean
	public SpringLiquibase docsLiquibase() {
		return springLiquibase(sampleDatasource1(), sampleDatasource1LiquibaseProperties());
	}
}
