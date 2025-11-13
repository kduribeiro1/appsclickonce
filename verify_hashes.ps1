# Script para verificar integridade dos arquivos ClickOnce

param(
    [string]$ManifestPath = "public\instaladores\ContatosLeonidio\ContatosLeonidio.application"
)

Write-Host "Verificando integridade dos arquivos ClickOnce..." -ForegroundColor Green
Write-Host ""

# Ler o manifesto principal
$manifestContent = Get-Content $ManifestPath -Raw

# Extrair informações do hash do manifesto principal
$xmlDoc = [xml]$manifestContent
$dependentAssembly = $xmlDoc.assembly.dependency.dependentAssembly

$expectedHash = $dependentAssembly.hash.'dsig:DigestValue'.'#text'
if (-not $expectedHash) {
    $expectedHash = $dependentAssembly.hash.'dsig:DigestValue'
}
$manifestFile = $dependentAssembly.codebase
$expectedSize = [int]$dependentAssembly.size

Write-Host "Manifest Principal: $ManifestPath" -ForegroundColor Cyan
Write-Host "Arquivo referenciado: $manifestFile" -ForegroundColor Cyan
Write-Host "Hash esperado: $expectedHash" -ForegroundColor Yellow
Write-Host "Tamanho esperado: $expectedSize bytes" -ForegroundColor Yellow
Write-Host ""

# Verificar se o arquivo existe
$fullPath = Join-Path "public\instaladores\ContatosLeonidio" $manifestFile
if (!(Test-Path $fullPath)) {
    Write-Host "ERRO: Arquivo não encontrado: $fullPath" -ForegroundColor Red
    exit 1
}

# Verificar tamanho do arquivo
$actualSize = (Get-Item $fullPath).Length
Write-Host "Tamanho atual: $actualSize bytes" -ForegroundColor White

if ($actualSize -ne $expectedSize) {
    Write-Host "ERRO: Tamanho incorreto! Esperado: $expectedSize, Atual: $actualSize" -ForegroundColor Red
} else {
    Write-Host "OK: Tamanho correto" -ForegroundColor Green
}

# Calcular hash SHA256 do arquivo
$fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$hashBytes = $sha256.ComputeHash($fileBytes)
$actualHash = [Convert]::ToBase64String($hashBytes)

Write-Host ""
Write-Host "Hash calculado: $actualHash" -ForegroundColor White
Write-Host "Hash esperado:  $expectedHash" -ForegroundColor Yellow

if ($actualHash -eq $expectedHash) {
    Write-Host "OK: Hashes coincidem!" -ForegroundColor Green
} else {
    Write-Host "ERRO: Hashes nao coincidem!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possíveis causas:" -ForegroundColor Yellow
    Write-Host "1. Vercel alterou o arquivo durante o deploy"
    Write-Host "2. Arquivo foi corrompido durante a copia"
    Write-Host "3. Encoding diferente (CRLF vs LF)"
    Write-Host "4. Compressao automatica do Vercel"
}

Write-Host ""

# Verificar encoding do arquivo
$content = Get-Content $fullPath -Raw
$utf8Content = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::UTF8.GetBytes($content))
$utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($utf8Content)
$utf8Hash = [Convert]::ToBase64String($sha256.ComputeHash($utf8Bytes))

Write-Host "Testando com UTF-8 forcado:" -ForegroundColor Cyan
Write-Host "Hash UTF-8: $utf8Hash" -ForegroundColor White

if ($utf8Hash -eq $expectedHash) {
    Write-Host "OK: Hash correto com UTF-8!" -ForegroundColor Green
} else {
    Write-Host "Ainda incorreto com UTF-8" -ForegroundColor Yellow
}

# Verificar com normalizacao de quebras de linha
$normalizedContent = $content -replace "`r`n", "`n"
$normalizedBytes = [System.Text.Encoding]::UTF8.GetBytes($normalizedContent)
$normalizedHash = [Convert]::ToBase64String($sha256.ComputeHash($normalizedBytes))

Write-Host ""
Write-Host "Testando com quebras de linha normalizadas (LF):" -ForegroundColor Cyan
Write-Host "Hash LF: $normalizedHash" -ForegroundColor White

if ($normalizedHash -eq $expectedHash) {
    Write-Host "OK: Hash correto com LF!" -ForegroundColor Green
} else {
    Write-Host "Ainda incorreto com LF" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Analise concluida!" -ForegroundColor Green