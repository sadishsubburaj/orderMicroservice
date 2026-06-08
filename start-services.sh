#!/bin/bash

# Start Microservices in Order
# This script starts all services in separate terminal windows/tabs

echo ""
echo "========================================"
echo "Starting Microservices Architecture"
echo "========================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "[1/4] Starting Discovery Server..."
open -a Terminal "$SCRIPT_DIR/discovery-server" || \
  ( cd "$SCRIPT_DIR/discovery-server" && mvn spring-boot:run ) &
DISCOVERY_PID=$!
echo "Discovery Server started (PID: $DISCOVERY_PID). Waiting 15 seconds for it to be ready..."
sleep 15

echo ""
echo "[2/4] Starting API Gateway..."
open -a Terminal "$SCRIPT_DIR/api-gateway" || \
  ( cd "$SCRIPT_DIR/api-gateway" && mvn spring-boot:run ) &
GATEWAY_PID=$!
echo "API Gateway started (PID: $GATEWAY_PID). Waiting 10 seconds..."
sleep 10

echo ""
echo "[3/4] Starting Payment Service..."
open -a Terminal "$SCRIPT_DIR/payment_service" || \
  ( cd "$SCRIPT_DIR/payment_service" && mvn spring-boot:run ) &
PAYMENT_PID=$!
echo "Payment Service started (PID: $PAYMENT_PID). Waiting 10 seconds..."
sleep 10

echo ""
echo "[4/4] Starting Order Service..."
open -a Terminal "$SCRIPT_DIR/order_service" || \
  ( cd "$SCRIPT_DIR/order_service" && mvn spring-boot:run ) &
ORDER_PID=$!
echo "Order Service started (PID: $ORDER_PID). Waiting 10 seconds..."
sleep 10

echo ""
echo "========================================"
echo "All services are starting!"
echo "========================================"
echo ""
echo "Service URLs:"
echo "  - Eureka Dashboard: http://localhost:8761/"
echo "  - API Gateway: http://localhost:8080/"
echo "  - Order Service: http://localhost:8081/"
echo "  - Payment Service: http://localhost:8082/"
echo ""
echo "Process IDs:"
echo "  - Discovery Server: $DISCOVERY_PID"
echo "  - API Gateway: $GATEWAY_PID"
echo "  - Payment Service: $PAYMENT_PID"
echo "  - Order Service: $ORDER_PID"
echo ""
echo "To stop all services, use:"
echo "  kill $DISCOVERY_PID $GATEWAY_PID $PAYMENT_PID $ORDER_PID"
echo ""
