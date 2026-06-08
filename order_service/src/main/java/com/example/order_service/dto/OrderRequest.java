package com.example.order_service.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record OrderRequest(

                @NotBlank String productName,

                @NotNull @Min(1) Integer quantity,

                @NotNull @Min(1) Double price) {
}