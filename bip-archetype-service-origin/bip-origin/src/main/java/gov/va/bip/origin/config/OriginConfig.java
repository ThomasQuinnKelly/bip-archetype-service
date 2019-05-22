package gov.va.bip.origin.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = { "gov.va.bip.framework.audit" },
		excludeFilters = @Filter(Configuration.class))
public class OriginConfig {

}