# generate_multi_api_sdks.ps1
# 
# Usage:
#   .\generate_multi_api_sdks.ps1 [-SkipJava] [-SkipFlutter] [-SkipPython]
#

param(
    [switch]$SkipJava,
    [switch]$SkipFlutter,
    [switch]$SkipPython
)

# ============================================================
# SETUP & DEPENDENCIES
# ============================================================
$ScriptRoot = $PSScriptRoot
$SdkRoot = $ScriptRoot

# Import modular generator scripts
. "$ScriptRoot\scripts\generator\Core.ps1"
. "$ScriptRoot\scripts\generator\Java.ps1"
. "$ScriptRoot\scripts\generator\Flutter.ps1"
. "$ScriptRoot\scripts\generator\Python.ps1"

# OpenAPI Specs
$PortfolioSpec = Join-Path $ScriptRoot "portfolio-openapi.json"

# Check specs
$hasPortfolio = Test-Path $PortfolioSpec

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Portfolio SDK Generator (Modular Mode) " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[CHECK] Available OpenAPI Specifications:"
Write-Host "  Portfolio API:   $(if($hasPortfolio){'[OK]'}else{'[MISSING]'})" -ForegroundColor $(if($hasPortfolio){'Green'}else{'Red'})
Write-Host ""

if (-not $hasPortfolio) {
    Write-Host "[ERROR] portfolio-openapi.json not found. Exiting." -ForegroundColor Red
    exit 1
}

# ============================================================
# GENERATION LOGIC
# ============================================================

# --- STEP 1: Java SDK ---
if (-not $SkipJava) {
    Write-Host "[STEP 1] Generating Java SDK..." -ForegroundColor Cyan
    
    Invoke-JavaGen `
        -Spec $PortfolioSpec `
        -OutDir (Join-Path $SdkRoot "java-portfolio-sdk") `
        -ArtifactId "am-portfolio-client" `
        -Description "AM Portfolio API Java Client" `
        -ApiPackage "com.am.portfolio.client.portfolio.api" `
        -ModelPackage "com.am.portfolio.client.portfolio.model" `
        -InvokerPackage "com.am.portfolio.client.portfolio.invoker" `
        -Label "java-portfolio"
    
    Write-Host ""
}

# --- STEP 2: Flutter SDK ---
if (-not $SkipFlutter) {
    Write-Host "[STEP 2] Generating Flutter SDK..." -ForegroundColor Cyan

    Invoke-FlutterGen `
        -Spec $PortfolioSpec `
        -OutDir (Join-Path $SdkRoot "flutter-portfolio-sdk") `
        -PubName "am_portfolio_client" `
        -PubDesc "AM Portfolio API Flutter Client" `
        -Label "flutter-portfolio"
    
    Write-Host ""
}

# --- STEP 3: Python SDK ---
if (-not $SkipPython) {
    Write-Host "[STEP 3] Generating Python SDK..." -ForegroundColor Cyan

    Invoke-PythonGen `
        -Spec $PortfolioSpec `
        -OutDir (Join-Path $SdkRoot "python-portfolio-sdk") `
        -PackageName "am_portfolio_client" `
        -ProjectName "am-portfolio-client" `
        -PyDesc "AM Portfolio API Python Client" `
        -Label "python-portfolio"
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " SDK Generation Complete! " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host ""
Write-Host "Packages generated (in am-portfolio-sdk/):"
Write-Host "  [Java]    java-portfolio-sdk/"
Write-Host "  [Flutter] flutter-portfolio-sdk/"
Write-Host "  [Python]  python-portfolio-sdk/"
Write-Host ""
