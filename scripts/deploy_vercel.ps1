<#
.SYNOPSIS
Builds the Flutter web app for proxy mode (no key in the bundle) and
deploys static build + api/ proxy to Vercel.

.PREREQS (one-time)
  1. vercel login
  2. Pick the LLM provider manually (no automatic fallback) and set its key:
       vercel env add LLM_PROVIDER   production   # "nvidia" (default) or "openai"
       vercel env add NVIDIA_API_KEY production   # when LLM_PROVIDER=nvidia
       vercel env add OPENAI_API_KEY production   # when LLM_PROVIDER=openai
       vercel env add NVIDIA_MODEL   production   # optional, default meta/llama-3.2-90b-vision-instruct
     Switch providers later by changing LLM_PROVIDER in the Vercel dashboard,
     then redeploy (rerun this script).

.PARAMETER Password
  Static access gate baked into the web bundle (client-side). Empty = no gate.

.USAGE
  powershell -File scripts\deploy_vercel.ps1 -Password "your-shared-password"
#>
param(
    [string]$Model = "gpt-4o",
    [string]$Password = ""
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$flutterBin = Join-Path $env:USERPROFILE ".puro\envs\stable\flutter\bin"
$env:Path = "$flutterBin;$env:Path"

Set-Location $projectRoot

Write-Host "Building web release in proxy mode (no API key in bundle)..." -ForegroundColor Cyan
flutter build web --release `
    --dart-define=OPENAI_BASE_URL=/api/openai/v1 `
    --dart-define=OPENAI_MODEL=$Model `
    --dart-define=APP_PASSWORD=$Password
if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }

Write-Host "Deploying to Vercel..." -ForegroundColor Cyan
vercel deploy --prod --yes
if ($LASTEXITCODE -ne 0) { throw "vercel deploy failed" }

Write-Host ""
Write-Host "Done. Open the printed URL on your iPhone, then Share -> Add to Home Screen." -ForegroundColor Green
Write-Host "Reminder: set a spending cap in the OpenAI dashboard - the URL is public."
