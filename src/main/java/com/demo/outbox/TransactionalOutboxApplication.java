package com.demo.outbox;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
public class TransactionalOutboxApplication {

    public static void main(String[] args) {
        SpringApplication.run(TransactionalOutboxApplication.class, args);
    }

}
