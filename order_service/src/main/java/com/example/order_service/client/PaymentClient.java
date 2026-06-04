package com.example.order_service.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.order_service.dto.PaymentRequest;
import com.example.order_service.dto.PaymentResponse;

@FeignClient(name = "payment-service")
public interface PaymentClient {

    @PostMapping("/payments")
    PaymentResponse createPayment(PaymentRequest request);
}