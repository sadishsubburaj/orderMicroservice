package com.example.paymentservice.event;

public record OrderCreatedEvent(Long orderId,
        String productName,
        Integer quantity,
        Double amount) {

}
