# Script PowerShell para Regenerar Manifestos ClickOnce
# Execute este script no PowerShell como Administrador

Write-Host "🔧 Regenerando manifestos ClickOnce..." -ForegroundColor Green

# Diretório do projeto ClickOnce
$ClickOnceDir = "public\instaladores\ContatosLeonidio\Application Files\ContatosLeonidio_2_0_0_4"

# Verificar se o diretório existe
if (-not (Test-Path $ClickOnceDir)) {
    Write-Host "❌ Erro: Diretório $ClickOnceDir não encontrado!" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Processando arquivos em: $ClickOnceDir" -ForegroundColor Yellow

# Listar arquivos .deploy
$deployFiles = Get-ChildItem -Path $ClickOnceDir -Filter "*.deploy" -Recurse
Write-Host "📋 Encontrados $($deployFiles.Count) arquivos .deploy" -ForegroundColor Cyan

# Função para calcular hash SHA256 em base64
function Get-Base64Hash {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        $hash = Get-FileHash -Algorithm SHA256 -Path $FilePath
        $bytes = [byte[]] -split ($hash.Hash -replace '..', '0x$&,')
        return [Convert]::ToBase64String($bytes)
    } else {
        return "Arquivo não encontrado: $FilePath"
    }
}

# Calcular hashes dos arquivos principais
Write-Host "📊 Calculando hashes dos arquivos principais..." -ForegroundColor Yellow

$mainFiles = @(
    "ContatosLeonidio.exe",
    "ContatosLeonidio.dll", 
    "Launcher.exe",
    "ContatosLeonidio.dll.config",
    "ContatosLeonidio.deps.json",
    "ContatosLeonidio.runtimeconfig.json"
)

foreach ($file in $mainFiles) {
    $filePath = Join-Path $ClickOnceDir $file
    $hash = Get-Base64Hash $filePath
    Write-Host "$file`: $hash" -ForegroundColor White
}

Write-Host ""
Write-Host "✅ Script concluído!" -ForegroundColor Green
Write-Host ""
Write-Host "🚨 PRÓXIMOS PASSOS OBRIGATÓRIOS:" -ForegroundColor Red
Write-Host "1. Abra o Visual Studio" -ForegroundColor White
Write-Host "2. Abra o projeto ContatosLeonidio" -ForegroundColor White
Write-Host "3. Vá em Project → Properties → Publish" -ForegroundColor White
Write-Host "4. Configure:" -ForegroundColor White
Write-Host "   - Publishing Folder Location: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/" -ForegroundColor Cyan
Write-Host "   - Installation Folder URL: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/" -ForegroundColor Cyan
Write-Host "5. Clique em 'Publish Now'" -ForegroundColor White
Write-Host "6. Substitua os arquivos gerados na pasta public/instaladores/ContatosLeonidio/" -ForegroundColor White
Write-Host ""
Write-Host "🔄 Ou use o MageUI.exe para atualizar os manifestos manualmente" -ForegroundColor Yellow

# Verificar se o MageUI.exe está disponível
$mageUI = Get-Command "MageUI.exe" -ErrorAction SilentlyContinue
if ($mageUI) {
    Write-Host "✅ MageUI.exe encontrado em: $($mageUI.Source)" -ForegroundColor Green
} else {
    Write-Host "⚠️  MageUI.exe não encontrado. Instale o Windows SDK." -ForegroundColor Yellow
}