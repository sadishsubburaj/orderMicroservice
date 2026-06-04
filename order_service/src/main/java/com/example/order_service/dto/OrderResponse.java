package com.example.order_service.dto;

public record OrderResponse(
        Long id,
        String productName,
        Integer quantity,
        Double price,
        String status) {
}