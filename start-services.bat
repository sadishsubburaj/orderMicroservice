@echo off
REM Start Microservices in Order
REM This script starts all services in separate terminal windows

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Starting Microservices Architecture
echo ========================================
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

echo [1/4] Starting Discovery Server...
start "Discovery Server - Port 8761" cmd /k "cd /d "%SCRIPT_DIR%discovery-server" && mvn spring-boot:run"
echo Discovery Server started. Waiting 15 seconds for it to be ready...
timeout /t 15 /nobreak

echo.
echo [2/4] Starting API Gateway...
start "API Gateway - Port 8080" cmd /k "cd /d "%SCRIPT_DIR%api-gateway" && mvn spring-boot:run"
echo API Gateway started. Waiting 10 seconds...
timeout /t 10 /nobreak

echo.
echo [3/4] Starting Payment Service...
start "Payment Service - Port 8082" cmd /k "cd /d "%SCRIPT_DIR%payment_service" && mvn spring-boot:run"
echo Payment Service started. Waiting 10 seconds...
timeout /t 10 /nobreak

echo.
echo [4/4] Starting Order Service...
start "Order Service - Port 8081" cmd /k "cd /d "%SCRIPT_DIR%order_service" && mvn spring-boot:run"
echo Order Service started. Waiting 10 seconds...
timeout /t 10 /nobreak

echo.
echo ========================================
echo All services are starting!
echo ========================================
echo.
echo Service URLs:
echo   - Eureka Dashboard: http://localhost:8761/
echo   - API Gateway: http://localhost:8080/
echo   - Order Service: http://localhost:8081/
echo   - Payment Service: http://localhost:8082/
echo.
echo NOTE: Each service runs in a separate terminal window.
echo To stop a service, close its terminal window or press Ctrl+C.
echo.
pause
