package com.example.order_service.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;

import com.example.order_service.dto.OrderRequest;
import com.example.order_service.dto.PaymentRequest;
import com.example.order_service.dto.PaymentResponse;
import com.example.order_service.entity.Order;
import com.example.order_service.event.OrderCreateEvent;
import com.example.order_service.repository.OrderRepository;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;

import com.example.order_service.client.*;

import lombok.*;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository repository;
    private final PaymentClient paymentClient;
    private boolean useFeign = false;
    private final OrderEventProducer producer;

    @CircuitBreaker(name = "paymentServiceCB", fallbackMethod = "paymentFallback")
    public Order create(OrderRequest request) {

        Order order = new Order();

        order.setProductName(request.productName());
        order.setQuantity(request.quantity());
        order.setPrice(request.price());

        Order savedOrder = repository.save(order);
        if (useFeign) {
            PaymentRequest paymentRequest = new PaymentRequest(savedOrder.getId(), savedOrder.getPrice());
            PaymentResponse paymentResponse = paymentClient.createPayment(paymentRequest);
            System.out.println("*************###" + paymentResponse.getStatus());

        } else {
            OrderCreateEvent event = new OrderCreateEvent(savedOrder.getId(), savedOrder.getProductName(),
                    savedOrder.getQuantity(),
                    savedOrder.getPrice());
            producer.publish(event);
        }
        return savedOrder;

    }

    public Order paymentFallback(
            OrderRequest request,
            Exception ex) {

        System.out.println(
                "Fallback Executed - Circuit Breaker triggered: " + ex.getMessage());

        Order order = new Order();

        order.setProductName(request.productName());
        order.setQuantity(request.quantity());
        order.setPrice(request.price());
        order.setStatus("PENDING_PAYMENT");
        Order savedOrder = repository.save(order);

        return savedOrder;
    }

    public List<Order> getAllOrders() {
        return repository.findAll();
    }

    public Order getOrder(Long id) {
        return repository.findById(id)
                .orElseThrow();
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }
}
