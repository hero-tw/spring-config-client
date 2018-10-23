package com.hero.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.env.CompositePropertySource;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.EnumerablePropertySource;
import org.springframework.core.env.PropertySource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoApplication {


	@Autowired
	ConfigurableEnvironment env;

	@Value("${config.name}")
	String name = "World";

	@RequestMapping("/")
	public String home() {

		CompositePropertySource awsParamSources = null;
		OUTER:
		for (PropertySource<?> propertySource : env.getPropertySources()) {
			if (propertySource.getName().equals("bootstrapProperties")) {
				CompositePropertySource bootstrap = (CompositePropertySource) propertySource;
				for (PropertySource<?> nestedSource : bootstrap.getPropertySources()) {
					if (nestedSource.getName().equals("aws-param-store")) {
						awsParamSources = (CompositePropertySource) nestedSource;
						break OUTER;
					}
				}
			}
		}
		if (awsParamSources == null) {
			System.out.println("No AWS Parameter Store PropertySource found");
		} else {
			System.out.println("Overview of all AWS Param Store property sources:\n");
			for (PropertySource<?> nestedSource : awsParamSources.getPropertySources()) {
				EnumerablePropertySource eps = (EnumerablePropertySource) nestedSource;
				System.out.println(eps.getName() + ":");
				for (String propName : eps.getPropertyNames()) {
					System.out.println("\t" + propName + " = " + eps.getProperty(propName));
				}
					Object temp = eps.getProperty("name");

					if (temp != null) {
						this.name = temp.toString();
						
					}
			}
		}

		return "Hello " + name;
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
