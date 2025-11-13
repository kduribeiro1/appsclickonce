# Script para republicar ClickOnce com URLs do GitHub Pages

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    [string]$TargetPath = "e:\CriacaoVS\appsclickonce\public\instaladores\ContatosLeonidio"
)

$githubPagesUrl = "https://kduribeiro1.github.io/appsclickonce"

Write-Host "=== REPUBLICACAO CLICKONCE PARA GITHUB PAGES ===" -ForegroundColor Green
Write-Host ""
Write-Host "URL do GitHub Pages: $githubPagesUrl" -ForegroundColor Yellow
Write-Host "Copiando de: $SourcePath" -ForegroundColor Cyan
Write-Host "Para: $TargetPath" -ForegroundColor Cyan
Write-Host ""

# Verificar se o diretório de origem existe
if (!(Test-Path $SourcePath)) {
    Write-Host "ERRO: Diretorio de origem nao encontrado: $SourcePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "INSTRUCOES:" -ForegroundColor Yellow
    Write-Host "1. Abra o Visual Studio"
    Write-Host "2. Abra o projeto ContatosLeonidio"
    Write-Host "3. Va em Project -> Publish ContatosLeonidio"
    Write-Host "4. Configure as URLs:"
    Write-Host "   Publishing Folder: $githubPagesUrl/instaladores/ContatosLeonidio/"
    Write-Host "   Installation URL:  $githubPagesUrl/instaladores/ContatosLeonidio/"
    Write-Host "5. Clique 'Publish'"
    Write-Host "6. Execute novamente este script com o caminho correto"
    exit 1
}

# Criar backup
$BackupPath = "$TargetPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (Test-Path $TargetPath) {
    Write-Host "Criando backup em: $BackupPath" -ForegroundColor Blue
    Copy-Item -Path $TargetPath -Destination $BackupPath -Recurse -Force
}

# Remover diretório atual
if (Test-Path $TargetPath) {
    Write-Host "Removendo arquivos antigos..." -ForegroundColor Yellow
    Remove-Item -Path $TargetPath -Recurse -Force
}

# Criar diretório de destino
Write-Host "Criando diretorio de destino..." -ForegroundColor Blue
New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null

# Copiar arquivos
Write-Host "Copiando arquivos..." -ForegroundColor Blue
try {
    Copy-Item -Path "$SourcePath\*" -Destination $TargetPath -Recurse -Force
    
    # Contar arquivos
    $FileCount = (Get-ChildItem -Path $TargetPath -Recurse -File | Measure-Object).Count
    $FolderCount = (Get-ChildItem -Path $TargetPath -Recurse -Directory | Measure-Object).Count
    
    Write-Host ""
    Write-Host "COPIA CONCLUIDA!" -ForegroundColor Green
    Write-Host "Arquivos copiados: $FileCount" -ForegroundColor White
    Write-Host "Pastas copiadas: $FolderCount" -ForegroundColor White
    
    # Verificar arquivos principais
    $MainFiles = @("ContatosLeonidio.application", "index.html")
    foreach ($file in $MainFiles) {
        $filePath = Join-Path $TargetPath $file
        if (Test-Path $filePath) {
            $size = (Get-Item $filePath).Length
            Write-Host "OK: $file ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "ERRO: $file nao encontrado" -ForegroundColor Red
        }
    }
    
    # Verificar Application Files
    $AppFilesPath = Join-Path $TargetPath "Application Files"
    if (Test-Path $AppFilesPath) {
        $versions = Get-ChildItem -Path $AppFilesPath -Directory | Sort-Object Name
        Write-Host "OK: Application Files ($($versions.Count) versoes)" -ForegroundColor Green
        $latestVersion = $versions | Select-Object -Last 1
        Write-Host "Versao mais recente: $($latestVersion.Name)" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host ""
    Write-Host "ERRO durante a copia:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== PROXIMOS PASSOS ===" -ForegroundColor Green
Write-Host "1. git add ."
Write-Host "2. git commit -m 'update: ClickOnce with GitHub Pages URLs'"
Write-Host "3. git push"
Write-Host "4. Aguardar deploy do GitHub Pages"
Write-Host "5. Testar: $githubPagesUrl/instaladores/ContatosLeonidio/ContatosLeonidio.application"

# Executar comandos git automaticamente
Write-Host ""
$gitResponse = Read-Host "Executar comandos git automaticamente? (s/n)"
if ($gitResponse -eq "s" -or $gitResponse -eq "S") {
    Write-Host ""
    Write-Host "Executando comandos git..." -ForegroundColor Blue
    
    Set-Location "e:\CriacaoVS\appsclickonce"
    
    git add .
    git commit -m "update: ClickOnce republished with GitHub Pages URLs"
    git push
    
    Write-Host ""
    Write-Host "GIT CONCLUIDO!" -ForegroundColor Green
    Write-Host ""
    Write-Host "GitHub Pages URL: $githubPagesUrl" -ForegroundColor Yellow
    Write-Host "Aguarde alguns minutos para o deploy e teste!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "MIGRACAO CONCLUIDA! GitHub Pages resolve o problema de hash validation." -ForegroundColor Green