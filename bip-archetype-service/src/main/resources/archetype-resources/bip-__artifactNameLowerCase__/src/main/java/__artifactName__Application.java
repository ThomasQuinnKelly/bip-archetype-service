#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package gov.va.bip.${artifactNameLowerCase};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableAsync;

import brave.sampler.Sampler;
import gov.va.bip.${artifactNameLowerCase}.config.${artifactName}Config;

/**
 * An <tt>${artifactName} Service Application</tt> enabled for Spring Boot Application,
 * Spring Cloud Netflix Feign Clients, Hystrix circuit breakers, Swagger and
 * AspectJ's @Aspect annotation.
 *
 */
@SpringBootApplication
@EnableDiscoveryClient // needed to reach out to spring cloud config, eureka
@EnableAspectJAutoProxy(proxyTargetClass = true)
@EnableFeignClients
@EnableHystrix
@EnableCaching
@EnableAsync
// Add any partner Config classes to @Import
@Import({ ${artifactName}Config.class })
public class ${artifactName}Application {

	/**
	 * Runs the spring-boot application with this class and any command-line arguments.
	 *
	 * @param args the array or command-line arguments
	 */
	public static void main(String[] args) {
		SpringApplication.run(${artifactName}Application.class, args);
	}

	/**
	 * Always sampler for Zipkin traces.
	 *
	 * @return the sampler
	 */
	@Bean
	Sampler alwaysSampler() {
		return Sampler.ALWAYS_SAMPLE;
	}

}
