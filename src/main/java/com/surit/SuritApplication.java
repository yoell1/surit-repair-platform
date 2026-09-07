package com.surit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SuritApplication {
	public static void main(String[] args) {
		SpringApplication.run(SuritApplication.class, args);
	}

}



