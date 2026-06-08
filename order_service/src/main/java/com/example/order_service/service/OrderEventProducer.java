package com.example.order_service.service;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import com.example.order_service.event.OrderCreateEvent;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrderEventProducer {

    private final KafkaTemplate<String, OrderCreateEvent> kafkaTemplate;

    public void publish(OrderCreateEvent event) {

        kafkaTemplate.send(
                "orders-topic",
                event.orderId().toString(),
                event);
    }
}
