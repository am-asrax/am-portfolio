# Core.ps1 - Shared Generator Utilities

function Invoke-OpenApiGen {
    param(
        [Parameter(Mandatory=$true)][string]$Spec,
        [Parameter(Mandatory=$true)][string]$OutDir,
        [Parameter(Mandatory=$true)][string]$Generator,
        [Parameter(Mandatory=$true)][hashtable]$Config,
        [string]$Label = "sdk"
    )

    Write-Host "[CORE] Generating $Label ($Generator)..." -ForegroundColor Yellow

    # Ensure output directory exists
    if (-not (Test-Path $OutDir)) {
        New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
    }

    # Prepare config string
    $configList = @()
    foreach ($key in $Config.Keys) {
        $configList += "$key=$($Config[$key])"
    }
    $additionalProps = $configList -join ","

    # Run OpenAPI Generator via npx
    npx -y @openapitools/openapi-generator-cli generate `
        -i $Spec `
        -g $Generator `
        -o $OutDir `
        --additional-properties $additionalProps `
        --skip-validate-spec

    Write-Host "[CORE] $Label generation completed." -ForegroundColor Green
}
