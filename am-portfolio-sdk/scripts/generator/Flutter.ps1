# Flutter.ps1 - Flutter/Dart SDK Generation Plugins

# Dot-source core
. $PSScriptRoot\Core.ps1

function Invoke-FlutterGen {
    param(
        [Parameter(Mandatory=$true)][string]$Spec,
        [Parameter(Mandatory=$true)][string]$OutDir,
        [Parameter(Mandatory=$true)][string]$PubName,
        [Parameter(Mandatory=$true)][string]$PubDesc,
        [hashtable]$BaseConfig = @{},
        [string]$Label = "flutter-sdk"
    )

    $fullConfig = $BaseConfig.Clone()
    $fullConfig["pubName"] = $PubName
    $fullConfig["pubDescription"] = $PubDesc
    $fullConfig["pubVersion"] = "1.0.0"

    # Call core generator
    Invoke-OpenApiGen -Spec $Spec -OutDir $OutDir -Generator "dart-dio" -Config $fullConfig -Label $Label
}
