# Start Microservices in Order
# This script starts all services in separate PowerShell windows

Write-Host ""
Write-Host "========================================"
Write-Host "Starting Microservices Architecture"
Write-Host "========================================"
Write-Host ""

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "[1/4] Starting Discovery Server..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\discovery-server'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "Discovery Server started. Waiting 15 seconds for it to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "[2/4] Starting API Gateway..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\api-gateway'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "API Gateway started. Waiting 10 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "[3/4] Starting Payment Service..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\payment_service'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "Payment Service started. Waiting 10 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "[4/4] Starting Order Service..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\order_service'; mvn spring-boot:run" -WindowStyle Normal
Write-Host "Order Service started. Waiting 10 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "========================================"
Write-Host "All services are starting!" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Green
Write-Host "  - Eureka Dashboard: http://localhost:8761/" 
Write-Host "  - API Gateway: http://localhost:8080/"
Write-Host "  - Order Service: http://localhost:8081/"
Write-Host "  - Payment Service: http://localhost:8082/"
Write-Host ""
Write-Host "NOTE: Each service runs in a separate terminal window." -ForegroundColor Yellow
Write-Host "To stop a service, close its terminal window or press Ctrl+C."
Write-Host ""
