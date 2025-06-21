package com.demo.outbox.repository;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PayloadRepository extends JpaRepository<PayloadRepository.Payload, UUID> {

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Entity
    @Table(name = "payload", schema="public")
    class Payload{
        @Id
        private UUID id;

        @Column(name = "value")
        private String value;
    }
}
