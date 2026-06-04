# Microservices Architecture Project

## Project Overview
This is a Spring Cloud-based microservices architecture demonstrating service-to-service communication, API Gateway routing, service discovery, and resilience patterns.

## Architecture

### Services Deployed
1. **Discovery Server (Eureka)** - Port 8761
   - Service registry and discovery
   - All services register automatically

2. **API Gateway** - Port 8080
   - MVC-based gateway routing requests to microservices
   - Load balancing via Eureka
   - Routes configured for:
     - `/orders/**` → ORDER-SERVICE (8081)
     - `/payments/**` → PAYMENT-SERVICE (8082)

3. **Order Service** - Port 8081
   - Manages order creation and retrieval
   - Communicates with Payment Service via OpenFeign
   - Implements circuit breaker pattern for payment failures
   - Database: H2 (in-memory)

4. **Payment Service** - Port 8082
   - Handles payment processing
   - Receives payment requests from Order Service
   - Database: H2 (in-memory)

## Technology Stack

| Component | Version |
|-----------|---------|
| Spring Boot | 3.4.6 |
| Spring Cloud | 2024.0.0 |
| Java | 21 |
| Maven | 3.8+ |
| Eureka Client | Netflix Eureka 2.0.4 |
| Resilience4j | (via Spring Cloud Starter) |
| OpenFeign | (Spring Cloud) |

## Project Structure

```
microservices/
├── pom.xml                          (Parent POM - Multi-module)
├── discovery-server/                (Eureka Server)
│   ├── pom.xml
│   └── src/main/resources/application.properties
├── order_service/                   (Order Microservice)
│   ├── pom.xml
│   ├── src/main/java/...
│   │   ├── OrderServiceApplication.java
│   │   ├── controller/OrderController.java
│   │   ├── service/OrderService.java
│   │   ├── entity/Order.java
│   │   ├── repository/OrderRepository.java
│   │   ├── dto/OrderRequest.java, OrderResponse.java
│   │   ├── dto/PaymentRequest.java, PaymentResponse.java
│   │   └── client/PaymentClient.java
│   └── src/main/resources/application.properties
├── payment_service/                 (Payment Microservice)
│   ├── pom.xml
│   ├── src/main/java/...
│   │   ├── PaymentServiceApplication.java
│   │   └── ...
│   └── src/main/resources/application.properties
└── api-gateway/                     (API Gateway)
    ├── pom.xml
    ├── src/main/java/...
    │   └── ApiGatewayApplication.java
    └── src/main/resources/application.properties
```

## Configuration Details

### Discovery Server (Eureka)
- **Port:** 8761
- **Eureka UI:** http://localhost:8761/
- **Configuration:**
  - Not registering itself as a client
  - Not fetching registry

### Order Service
- **Port:** 8081
- **H2 Console:** http://localhost:8081/h2-console
- **Eureka Registration:** Yes (registered as ORDER-SERVICE)
- **Circuit Breaker:** Enabled for Payment Service calls
  - **Instance Name:** paymentServiceCB
  - **Failure Rate Threshold:** 50%
  - **Minimum Calls:** 2
  - **Sliding Window Size:** 2
  - **Wait Duration:** 10s
  - **Automatic Transition:** Enabled

### Payment Service
- **Port:** 8082
- **H2 Console:** http://localhost:8082/h2-console
- **Eureka Registration:** Yes (registered as PAYMENT-SERVICE)

### API Gateway
- **Port:** 8080
- **Gateway Type:** MVC-based (spring-cloud-starter-gateway-mvc)
- **Routing:**
  - Predicate: Path-based routing
  - Load Balancer: Enabled via Eureka
  - Client-side load balancing via Spring Cloud Load Balancer

## Running the Services

### Prerequisites
- Java 21 installed
- Maven 3.8+ installed

### Build All Services
```bash
cd microservices
mvn clean install -U
```

### Run Services (in this order)

1. **Start Discovery Server:**
```bash
cd discovery-server
mvn spring-boot:run
```

2. **Start Payment Service:**
```bash
cd payment_service
mvn spring-boot:run
```

3. **Start Order Service:**
```bash
cd order_service
mvn spring-boot:run
```

4. **Start API Gateway:**
```bash
cd api-gateway
mvn spring-boot:run
```

### Verify Services

1. **Check Eureka Dashboard:**
   - URL: http://localhost:8761/
   - Should show 3 registered services: ORDER-SERVICE, PAYMENT-SERVICE, API-GATEWAY

2. **Create an Order:**
```bash
curl -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{
    "productName": "Laptop",
    "quantity": 1,
    "price": 999.99
  }'
```

3. **Get All Orders:**
```bash
curl http://localhost:8080/orders
```

4. **Get Order by ID:**
```bash
curl http://localhost:8080/orders/1
```

## Key Features Implemented

### 1. Service Discovery
- ✅ Eureka-based service registry
- ✅ Automatic service registration
- ✅ Health checks and lease renewal configuration

### 2. API Gateway
- ✅ MVC-based routing (not reactive)
- ✅ Predicate-based path routing
- ✅ Load balancing via Eureka
- ✅ Support for multiple routes

### 3. Inter-Service Communication
- ✅ OpenFeign for declarative REST client
- ✅ Eureka name-based routing (lb://SERVICE-NAME)
- ✅ Automatic service discovery

### 4. Resilience Patterns
- ✅ Circuit Breaker Pattern (Resilience4j)
- ✅ Fallback methods for failures
- ✅ Configurable thresholds and timeouts
- ✅ Automatic state transitions (CLOSED → OPEN → HALF_OPEN)

### 5. Database
- ✅ H2 in-memory database for all services
- ✅ JPA/Hibernate ORM
- ✅ H2 Console enabled for development

### 6. Logging
- ✅ SLF4J logging configured
- ✅ Eureka debug logging enabled
- ✅ Circuit breaker state transitions logged

## Fixes Applied

### Issue 1: Payment Service Not Showing in Java Projects Tab
**Solution:** Created parent pom.xml at root level to define both services as modules

### Issue 2: Spring Boot/Spring Cloud Version Incompatibility
**Solution:** Aligned all services to Spring Boot 3.4.6 with Spring Cloud 2024.0.0

### Issue 3: Lombok Annotation Processing
**Solution:** 
- Changed Lombok scope from `optional=true` to `provided`
- Added explicit annotation processor configuration in maven-compiler-plugin
- Ensured proper compiler plugin version (3.13.0)

### Issue 4: Eureka Registration Failures
**Solution:**
- Added Eureka client registration configuration
- Set faster registration intervals
- Configured proper lease renewal timeouts

### Issue 5: API Gateway Version Mismatch
**Solution:** Unified API Gateway to Spring Boot 3.4.6 matching all other services

### Issue 6: Circuit Breaker Not Triggering Fallback
**Issues Found & Fixed:**
1. **Case Mismatch:** Config used `paymentService` but annotation used `PaymentService` (case-sensitive)
   - **Fix:** Changed both to use `paymentServiceCB`

2. **Missing Circuit Breaker Starter:** 
   - **Fix:** Added `spring-cloud-starter-circuitbreaker-resilience4j` dependency

3. **Fallback Method Signature:**
   - **Fix:** Used generic `Exception` type in fallback to avoid ClassNotFoundException

## Configuration Files Modified

### Parent pom.xml
- Defines multi-module structure
- Java 21 configuration
- No dependencies (inherits from Spring Boot parent)

### All Service pom.xml Files
- Spring Boot 3.4.6
- Spring Cloud 2024.0.0 dependencies
- Lombok with proper annotation processing
- Resilience4j circuit breaker
- OpenFeign (for order service)
- Eureka client
- H2 database

### application.properties (All Services)
- Service name and port
- Eureka registration details
- Database configuration
- H2 Console settings
- Circuit breaker configuration (Order Service)
- Gateway routes (API Gateway)
- Load balancer settings (API Gateway)

## Monitoring & Debugging

### Eureka Health Check
```bash
curl http://localhost:8761/eureka/apps
```

### Circuit Breaker State
- Check logs for "Fallback Executed" messages
- Monitor circuit breaker state transitions in application logs

### Database Access
- Order Service H2: http://localhost:8081/h2-console
- Payment Service H2: http://localhost:8082/h2-console
- JDBC URL: jdbc:h2:mem:orderdb (order) or jdbc:h2:mem:paymentdb (payment)
- Username: sa
- Password: (leave blank)

## Testing Circuit Breaker

1. **Stop Payment Service** to trigger failures
2. **Make order creation requests** via API Gateway
3. **Observe circuit breaker behavior:**
   - Initial calls fail with error
   - After threshold reached, circuit opens
   - Fallback method creates order with "PENDING_PAYMENT" status
   - After 10 seconds, circuit transitions to HALF_OPEN
   - Service attempts to call Payment Service again

## Future Enhancements

- [ ] Add distributed tracing (Sleuth + Zipkin)
- [ ] Implement rate limiting
- [ ] Add authentication/authorization (OAuth2/JWT)
- [ ] Implement saga pattern for distributed transactions
- [ ] Add metrics and monitoring (Micrometer + Prometheus)
- [ ] Implement message-driven communication (Kafka/RabbitMQ)
- [ ] Add API documentation (Swagger/OpenAPI)
- [ ] Implement caching layer (Redis)

## Troubleshooting

### Services Not Registering with Eureka
1. Verify Discovery Server is running on port 8761
2. Check `eureka.client.service-url.defaultZone` in each service
3. Restart services after fixing configuration

### Circuit Breaker Not Activating
1. Verify configuration name matches annotation: `paymentServiceCB`
2. Check that `spring-cloud-starter-circuitbreaker-resilience4j` is in pom.xml
3. Ensure minimum-number-of-calls threshold is reached before circuit opens
4. Check logs for circuit breaker state changes

### API Gateway Not Routing Requests
1. Verify services are registered in Eureka
2. Check route predicates and URIs in application.properties
3. Ensure service names match Eureka registration names (case-sensitive)
4. Verify port 8080 is accessible

### H2 Console Not Accessible
1. Ensure `spring.h2.console.enabled=true` in application.properties
2. URL should be: `http://localhost:PORT/h2-console`
3. Login with username 'sa' and empty password

## Version Control
All configuration files and source code managed in version control.

## Contact & Support
For issues or questions, refer to the Spring Cloud documentation:
- https://spring.io/projects/spring-cloud
- https://resilience4j.readme.io/
- https://cloud.spring.io/spring-cloud-netflix/

---
**Last Updated:** June 5, 2026
