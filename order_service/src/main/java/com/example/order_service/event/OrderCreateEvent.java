package com.example.order_service.event;

public record OrderCreateEvent(Long orderId,
        String productName,
        Integer quantity,
        Double amount) {

}
