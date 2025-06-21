package com.demo.outbox.service;

import com.demo.outbox.repository.OutboxRepository;
import com.demo.outbox.repository.PayloadRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static com.demo.outbox.repository.OutboxRepository.OutboxEvent;
import static com.demo.outbox.repository.PayloadRepository.Payload;

@Service
public class DemoService {

    private final OutboxRepository outboxRepository;
    private final PayloadRepository payloadRepository;
    private final ObjectMapper objectMapper;

    public DemoService(OutboxRepository outboxRepository, PayloadRepository payloadRepository,
                       ObjectMapper objectMapper) {
        this.outboxRepository = outboxRepository;
        this.payloadRepository = payloadRepository;
        this.objectMapper = objectMapper;
    }

    @Transactional
    public void persist() throws JsonProcessingException {
        Payload payload = new Payload(UUID.randomUUID(), "Demo Payload Value");
        payloadRepository.save(payload);

        OutboxEvent outboxEvent = new OutboxEvent(
                UUID.randomUUID(),
                "demo.destination",
                objectMapper.writeValueAsString(payload),
                java.time.Instant.now()
        );
        outboxRepository.save(outboxEvent);
    }
}
