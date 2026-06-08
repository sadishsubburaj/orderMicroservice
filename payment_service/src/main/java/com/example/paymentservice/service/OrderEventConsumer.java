package com.example.paymentservice.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.example.paymentservice.entity.Payment;
import com.example.paymentservice.event.OrderCreatedEvent;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrderEventConsumer {

    private final PaymentService paymentService;
    @Value("${server.port}")
    private String port;

    @KafkaListener(topics = "orders-topic", groupId = "payment-service-group")
    public void consumeOrderCreatedEvent(OrderCreatedEvent event) {
        System.out.println("Order event received: " + event + " " + port);

        if (event.amount() > 10000) {
            throw new RuntimeException("Payment processing failed");
        }
        System.out.println("payment done successfully");
        Payment payment = new Payment();
        payment.setAmount(event.amount());
        payment.setOrderId(event.orderId());
        paymentService.createPayment(payment);
        try {
            Thread.sleep(5000);
        } catch (Exception e) {

        }
    }
}
