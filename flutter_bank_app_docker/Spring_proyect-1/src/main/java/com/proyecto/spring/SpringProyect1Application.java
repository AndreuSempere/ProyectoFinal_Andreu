package com.proyecto.spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringProyect1Application {

	private static final Logger logger = LoggerFactory.getLogger(SpringProyect1Application.class);

    public static void main(String[] args) {
        logger.info("Iniciando la aplicación Spring Boot");
        SpringApplication.run(SpringProyect1Application.class, args);
        logger.info("Aplicación Spring Boot iniciada");
    }

}
