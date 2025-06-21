package com.demo.outbox.repository;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.util.UUID;

public interface OutboxRepository extends JpaRepository<OutboxRepository.OutboxEvent, UUID> {

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Entity
    @Table(name = "outbox_events", schema="public")
    class OutboxEvent {
        @Id
        private UUID id;

        @Column
        private String destination;

        @Column
        private String payload;

        @Column
        private Instant timestamp;
    }
}
