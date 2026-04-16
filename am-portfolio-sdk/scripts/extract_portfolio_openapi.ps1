# Portfolio OpenAPI Extraction Script
# Starts the service temporarily, extracts the spec, and stops it

param(
    [int]$Port = 8060,
    [string]$OutputFile = "portfolio-openapi.json"
)

$ErrorActionPreference = "Stop"

Write-Host "[START] Portfolio OpenAPI Extraction" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SdkRoot = Split-Path -Parent $ScriptDir
$PortfolioApp = Join-Path (Split-Path -Parent $SdkRoot) "portfolio-app"
$OutputPath = Join-Path $SdkRoot $OutputFile

Write-Host "[INFO] Portfolio App: $PortfolioApp" -ForegroundColor Gray
Write-Host "[INFO] Output Path: $OutputPath" -ForegroundColor Gray

# Check if portfolio-app exists
if (-not (Test-Path $PortfolioApp)) {
    Write-Host "[ERROR] Portfolio App not found at: $PortfolioApp" -ForegroundColor Red
    exit 1
}

# Change to portfolio-app directory
Push-Location $PortfolioApp

$process = $null

try {
    Write-Host ""
    Write-Host "[STEP 1] Starting Portfolio Service..." -ForegroundColor Yellow
    
    # Start the Spring Boot application in background
    $process = Start-Process -FilePath "mvn" `
        -ArgumentList "spring-boot:run", "-Dspring-boot.run.jvmArguments=-Dserver.port=$Port" `
        -PassThru `
        -NoNewWindow `
        -RedirectStandardOutput "$env:TEMP\portfolio-startup.log" `
        -RedirectStandardError "$env:TEMP\portfolio-startup-error.log"
    
    Write-Host "   Process ID: $($process.Id)" -ForegroundColor Gray
    
    # Wait for service to be ready
    Write-Host "[STEP 2] Waiting for service startup..." -ForegroundColor Yellow
    $maxAttempts = 60
    $attempt = 0
    $ready = $false
    
    while ($attempt -lt $maxAttempts -and -not $ready) {
        Start-Sleep -Seconds 2
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:$Port/actuator/health" `
                -TimeoutSec 2 `
                -ErrorAction SilentlyContinue
            
            if ($response.StatusCode -eq 200) {
                $ready = $true
                Write-Host "   [OK] Service is ready!" -ForegroundColor Green
            }
        }
        catch {
            $attempt++
            if ($attempt % 5 -eq 0) {
                Write-Host "   ... still waiting ($attempt/$maxAttempts)" -ForegroundColor Gray
            }
        }
    }
    
    if (-not $ready) {
        Write-Host "   [ERROR] Service failed to start within timeout" -ForegroundColor Red
        Write-Host "   [LOG] Check logs at: $env:TEMP\portfolio-startup.log" -ForegroundColor Yellow
        throw "Service startup timeout"
    }
    
    # Extract OpenAPI spec
    Write-Host "[STEP 3] Extracting OpenAPI specification..." -ForegroundColor Yellow
    
    $openApiUrl = "http://localhost:$Port/v3/api-docs"
    Write-Host "   URL: $openApiUrl" -ForegroundColor Gray
    
    $spec = Invoke-RestMethod -Uri $openApiUrl -TimeoutSec 30
    
    # Save to file
    $spec | ConvertTo-Json -Depth 100 | Out-File -FilePath $OutputPath -Encoding UTF8
    
    Write-Host "   [OK] Spec extracted successfully!" -ForegroundColor Green
    Write-Host "   [INFO] Title: $($spec.info.title)" -ForegroundColor Gray
    Write-Host "   [INFO] Version: $($spec.info.version)" -ForegroundColor Gray
    Write-Host "   [INFO] Paths: $($spec.paths.Count)" -ForegroundColor Gray
    Write-Host "   [FILE] Saved to: $OutputPath" -ForegroundColor Gray
    
}
catch {
    Write-Host "[ERROR] Failed to extract OpenAPI spec: $_" -ForegroundColor Red
    throw
}
finally {
    # Stop the service
    Write-Host "[STEP 4] Stopping service..." -ForegroundColor Yellow
    
    if ($process -and -not $process.HasExited) {
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        Write-Host "   [OK] Service stopped (PID: $($process.Id))" -ForegroundColor Green
    }
    
    Pop-Location
}

Write-Host ""
Write-Host "[SUCCESS] OpenAPI extraction complete!" -ForegroundColor Green
Write-Host "[OUTPUT] $OutputPath" -ForegroundColor Cyan
