# Python.ps1 - Python SDK Generation Plugins

# Dot-source core
. $PSScriptRoot\Core.ps1

function Invoke-PythonGen {
    param(
        [Parameter(Mandatory=$true)][string]$Spec,
        [Parameter(Mandatory=$true)][string]$OutDir,
        [Parameter(Mandatory=$true)][string]$PackageName,
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [Parameter(Mandatory=$true)][string]$PyDesc,
        [hashtable]$BaseConfig = @{},
        [string]$Label = "python-sdk"
    )

    $fullConfig = $BaseConfig.Clone()
    $fullConfig["packageName"] = $PackageName
    $fullConfig["projectName"] = $ProjectName
    $fullConfig["packageVersion"] = "1.0.0"
    $fullConfig["packageDescription"] = $PyDesc

    # Call core generator
    Invoke-OpenApiGen -Spec $Spec -OutDir $OutDir -Generator "python" -Config $fullConfig -Label $Label
}
