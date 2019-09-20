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
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariDataSource;

import liquibase.integration.spring.SpringLiquibase;

/**
 * Configuration for the datasource named sampleDatasource2, entity manager factory, transaction manager, and liquibase beans.
 *
 * @author aburkholder
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(entityManagerFactoryRef = "sampleDatasource2EntityManagerFactory", transactionManagerRef = "sampleDatasource2TransactionManager",
// jpa repo base package
basePackages = "gov.va.bip.origin.data.sampledatasource2")
public class sampleDatasource2Config extends OriginDatasourceBase {

	private static final String SAMPLE_DATASOURCE2_JPA_PREFIX = "db.jpa.sampledatasource2";
	private static final String SAMPLE_DATASOURCE2_DATASOURCE_PREFIX = "db.datasource.sampledatasource2";
	private static final String SAMPLE_DATASOURCE2_HIKARI_DATASOURCE_PREFIX = "db.datasource.sampledatasource2.hikari";
	private static final String SAMPLE_DATASOURCE2_LIQUIBASE_PROPERTY_PREFIX = "db.liquibase.sampledatasource2";
	private static final String SAMPLE_DATASOURCE2_PERSISTENCE_UNIT = "sampleDatasource2";

	private static final String[] SAMPLE_DATASOURCE2_ENTITIES_PACKAGES =
			{ "gov.va.bip.origin.data.sampledatasource2.entities" };

	/**
	 * Properties for the datasource and to populate liquibase config.
	 *
	 * @return DataSourceProperties
	 */
	@Bean
	@ConfigurationProperties(SAMPLE_DATASOURCE2_DATASOURCE_PREFIX)
	public DataSourceProperties sampleDatasource2Properties() {
		return new DataSourceProperties();
	}

	/**
	 * sampleDatasource2 for sample database2, via hikari datasource pool.
	 * <p>
	 * Application yaml configures this datasource with db.datasource.sampleDatasource2.** properties.
	 * <p>
	 * This datasource puts all values into the hikari config, but does not populate the "normal" datasource properties (url, user,
	 * pass). These values are manually added back so that liquibase can be initiated correctly.
	 *
	 * @return DataSource - the datasource Called sampleDatasource2
	 */
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE2_HIKARI_DATASOURCE_PREFIX)
	public HikariDataSource sampleDatasource2() {
		return sampleDatasource2Properties().initializeDataSourceBuilder().type(HikariDataSource.class).build();
	}

	/**
	 * Entity Manager for sampleDatasource2 entities.
	 *
	 * @param builder a builder for entity manager factory
	 * @param dataSource must be the "sampleDatasource2" bean
	 * @return LocalContainerEntityManagerFactoryBean entity manager for sampleDatasource2
	 */
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE2_JPA_PREFIX)
	public LocalContainerEntityManagerFactoryBean sampleDatasource2EntityManagerFactory(final EntityManagerFactoryBuilder builder,
			@Qualifier("sampleDatasource2") final DataSource dataSource) {
		return builder.dataSource(dataSource).packages(SAMPLE_DATASOURCE2_ENTITIES_PACKAGES)
				.persistenceUnit(SAMPLE_DATASOURCE2_PERSISTENCE_UNIT).build();
	}

	/**
	 * Transaction Manager for sampleDatasource2 entities.
	 *
	 * @param entityManagerFactory must be the "sampleDatasource2EntityManagerFactory" bean
	 * @return PlatformTransactionManager transaction manager for sampleDatasource2EntityManagerFactory
	 */
	@Bean
	public PlatformTransactionManager
	sampleDatasource2TransactionManager(
			@Qualifier("sampleDatasource2EntityManagerFactory") final EntityManagerFactory entityManagerFactory) {
		return new JpaTransactionManager(entityManagerFactory);
	}

	/**
	 * Bean for liquibase properties.
	 *
	 * @return LiquibaseProperties properties for liquibase
	 */
	@Bean
	@ConfigurationProperties(prefix = SAMPLE_DATASOURCE2_LIQUIBASE_PROPERTY_PREFIX)
	public LiquibaseProperties sampleDatasource2LiquibaseProperties() {
		return new LiquibaseProperties();
	}

	/**
	 * The liquibase object configured for the datasource with the liquibase properties.
	 *
	 * @return SpringLiquibase
	 */
	@Bean
	public SpringLiquibase sampleDatasource2Liquibase() {
		return springLiquibase(sampleDatasource2(), sampleDatasource2LiquibaseProperties());
	}
}
