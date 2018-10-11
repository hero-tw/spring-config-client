package com.hero.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Configuration
@RestController
@SpringBootApplication
public class DemoApplication {

	@Value("${config.name}")
	String name = "World";

	@RequestMapping("/")
	public String home() {
		return "Hello " + name;
	}


	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}