# AM Portfolio SDK Generator
# Generates Java, Python, and Flutter SDKs from the Portfolio OpenAPI spec.
# Usage:
#   .\generate_sdks.ps1              # Generate all SDKs
#   .\generate_sdks.ps1 -SkipPython  # Skip Python, generate Java + Flutter
#   .\generate_sdks.ps1 -SkipJava    # Skip Java
#   .\generate_sdks.ps1 -SkipFlutter # Skip Flutter
# Requires: Node.js (npx) OR have npx available.
param(
    [switch]$SkipJava,
    [switch]$SkipFlutter,
    [switch]$SkipPython
)

# ============================================================
$ScriptRoot = $PSScriptRoot
$SdkRoot = $ScriptRoot

# Import modular generator scripts
. "$ScriptRoot\scripts\generator\Core.ps1"
. "$ScriptRoot\scripts\generator\Java.ps1"
. "$ScriptRoot\scripts\generator\Flutter.ps1"
. "$ScriptRoot\scripts\generator\Python.ps1"

# OpenAPI Spec
$PortfolioSpec = Join-Path $ScriptRoot "portfolio-openapi.json"

# Check spec
$hasPortfolio = Test-Path $PortfolioSpec

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " AM Portfolio SDK Generator             " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[CHECK] Available OpenAPI Specifications:"
Write-Host "  Portfolio API: $(if($hasPortfolio){'[OK]'}else{'[MISSING]'})" -ForegroundColor $(if($hasPortfolio){'Green'}else{'Red'})
Write-Host ""

if (-not $hasPortfolio) {
    Write-Host "[ERROR] No OpenAPI specification found. Run the extraction script first:" -ForegroundColor Red
    Write-Host "   .\scripts\extract_portfolio_openapi.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Or manually extract:" -ForegroundColor Yellow
    Write-Host "   curl http://localhost:8060/v3/api-docs -o portfolio-openapi.json" -ForegroundColor Yellow
    exit 1
}

# --- STEP 1: Java SDK ---
if (-not $SkipJava) {
    Write-Host "[STEP 1] Generating Java SDK..." -ForegroundColor Cyan

    Invoke-JavaGen `
        -Spec $PortfolioSpec `
        -OutDir (Join-Path $SdkRoot "java-portfolio-sdk") `
        -ArtifactId "am-portfolio-client" `
        -Description "AM Portfolio API Java Client" `
        -ApiPackage "com.am.portfolio.client.api" `
        -ModelPackage "com.am.portfolio.client.model" `
        -InvokerPackage "com.am.portfolio.client.invoker" `
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
Write-Host " SDK Generation Complete!               " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Packages generated (in am-portfolio-sdk/):"
if (-not $SkipJava)    { Write-Host "  [Java]    java-portfolio-sdk/" }
if (-not $SkipFlutter) { Write-Host "  [Flutter] flutter-portfolio-sdk/" }
if (-not $SkipPython)  { Write-Host "  [Python]  python-portfolio-sdk/" }
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review the generated code"
Write-Host "  2. Commit and push to trigger the SDK publish workflow"
Write-Host ""
