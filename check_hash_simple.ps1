# Script simplificado para verificar hash ClickOnce

$manifestPath = "public\instaladores\ContatosLeonidio\ContatosLeonidio.application"

Write-Host "Analisando manifesto ClickOnce..." -ForegroundColor Green

# Ler o conteudo raw do manifesto
$content = Get-Content $manifestPath -Raw
Write-Host "Conteudo do manifesto (primeiras 500 chars):"
Write-Host $content.Substring(0, [Math]::Min(500, $content.Length)) -ForegroundColor Gray
Write-Host ""

# Procurar pelo hash usando regex
if ($content -match '<dsig:DigestValue>(.*?)</dsig:DigestValue>') {
    $expectedHash = $matches[1]
    Write-Host "Hash extraido do manifesto: $expectedHash" -ForegroundColor Yellow
} else {
    Write-Host "ERRO: Nao foi possivel extrair o hash do manifesto" -ForegroundColor Red
    exit 1
}

# Procurar pelo arquivo referenciado (dependentAssembly, não deploymentProvider)
if ($content -match 'dependentAssembly[^>]*codebase="([^"]*)"') {
    $manifestFile = $matches[1]
    Write-Host "Arquivo referenciado: $manifestFile" -ForegroundColor Cyan
} else {
    Write-Host "ERRO: Nao foi possivel extrair o codebase do dependentAssembly" -ForegroundColor Red
    exit 1
}

# Procurar pelo tamanho
if ($content -match 'size="(\d+)"') {
    $expectedSize = [int]$matches[1]
    Write-Host "Tamanho esperado: $expectedSize bytes" -ForegroundColor Cyan
} else {
    Write-Host "ERRO: Nao foi possivel extrair o tamanho" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Verificar o arquivo
$fullPath = Join-Path "public\instaladores\ContatosLeonidio" $manifestFile
if (!(Test-Path $fullPath)) {
    Write-Host "ERRO: Arquivo nao encontrado: $fullPath" -ForegroundColor Red
    exit 1
}

$actualSize = (Get-Item $fullPath).Length
Write-Host "Arquivo atual: $fullPath" -ForegroundColor White
Write-Host "Tamanho atual: $actualSize bytes" -ForegroundColor White

# Calcular hash
$fileBytes = [System.IO.File]::ReadAllBytes($fullPath)
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$hashBytes = $sha256.ComputeHash($fileBytes)
$actualHash = [Convert]::ToBase64String($hashBytes)

Write-Host ""
Write-Host "=== COMPARACAO DE HASHES ===" -ForegroundColor Green
Write-Host "Hash esperado: $expectedHash" -ForegroundColor Yellow
Write-Host "Hash atual:    $actualHash" -ForegroundColor Yellow

if ($actualHash -eq $expectedHash) {
    Write-Host "SUCESSO: Hashes coincidem!" -ForegroundColor Green
} else {
    Write-Host "ERRO: Hashes diferentes!" -ForegroundColor Red
    
    # Tentar com diferentes encodings
    Write-Host ""
    Write-Host "Testando solucoes alternativas..." -ForegroundColor Cyan
    
    # Verificar tamanho primeiro
    if ($actualSize -ne $expectedSize) {
        Write-Host "PROBLEMA: Tamanho diferente! Arquivo pode ter sido modificado." -ForegroundColor Red
    }
    
    # Tentar recriar o hash correto
    Write-Host ""
    Write-Host "Para corrigir, você precisa:" -ForegroundColor Yellow
    Write-Host "1. Republicar no Visual Studio"
    Write-Host "2. Usar um servidor que nao modifique os arquivos"
    Write-Host "3. Ou configurar o Vercel para nao processar arquivos .manifest"
}

$sha256.Dispose()