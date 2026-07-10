<#
.SYNOPSIS
Builds the Flutter web app with your OpenAI key and serves it on the local
network so an iPhone on the same Wi-Fi can open it in Safari.

.USAGE
powershell -File scripts\serve_iphone.ps1 -ApiKey "sk-your-key"

Then on the iPhone (same Wi-Fi): open the printed URL in Safari,
tap Share -> Add to Home Screen.

SECURITY: the API key is compiled into the JavaScript bundle. Serve on your
own network only — never host this build publicly.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ApiKey,

    [string]$Model = "gpt-4o",
    [int]$Port = 8080,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$flutterBin = Join-Path $env:USERPROFILE ".puro\envs\stable\flutter\bin"
$env:Path = "$flutterBin;$env:Path"

Set-Location $projectRoot

if (-not $SkipBuild) {
    Write-Host "Building web release (key baked in, model: $Model)..." -ForegroundColor Cyan
    flutter build web --release `
        --dart-define=OPENAI_API_KEY=$ApiKey `
        --dart-define=OPENAI_MODEL=$Model
    if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }
}

$ips = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
    Select-Object -ExpandProperty IPAddress

Write-Host ""
Write-Host "Serving build\web on port $Port. Open on your iPhone (same Wi-Fi):" -ForegroundColor Green
foreach ($ip in $ips) {
    Write-Host "  http://${ip}:$Port" -ForegroundColor Yellow
}
Write-Host "Then: Safari -> Share -> Add to Home Screen. Ctrl+C stops the server."
Write-Host ""

py -m http.server $Port --directory (Join-Path $projectRoot "build\web") --bind 0.0.0.0
