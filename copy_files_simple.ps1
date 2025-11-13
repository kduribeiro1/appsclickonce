# Script para copiar arquivos publicados do Visual Studio para o projeto Vercel

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    [string]$TargetPath = "e:\CriacaoVS\appsclickonce\public\instaladores\ContatosLeonidio"
)

Write-Host "Iniciando copia dos arquivos publicados..." -ForegroundColor Green

# Verificar se o diretório de origem existe
if (!(Test-Path $SourcePath)) {
    Write-Host "ERRO: Diretorio de origem nao encontrado: $SourcePath" -ForegroundColor Red
    Write-Host "Como usar este script:"
    Write-Host "1. Republique o projeto ContatosLeonidio no Visual Studio"
    Write-Host "2. Anote o caminho onde os arquivos foram publicados"
    Write-Host "3. Execute: .\copy_files_simple.ps1 -SourcePath 'CAMINHO_DA_PUBLICACAO'"
    exit 1
}

# Criar backup do diretório atual
$BackupPath = "$TargetPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (Test-Path $TargetPath) {
    Write-Host "Criando backup em: $BackupPath" -ForegroundColor Blue
    Copy-Item -Path $TargetPath -Destination $BackupPath -Recurse -Force
}

# Remover diretório atual se existir
if (Test-Path $TargetPath) {
    Write-Host "Removendo arquivos antigos..." -ForegroundColor Yellow
    Remove-Item -Path $TargetPath -Recurse -Force
}

# Criar diretório de destino
Write-Host "Criando diretorio de destino..." -ForegroundColor Blue
New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null

# Copiar todos os arquivos
Write-Host "Copiando arquivos de $SourcePath para $TargetPath..." -ForegroundColor Blue
try {
    Copy-Item -Path "$SourcePath\*" -Destination $TargetPath -Recurse -Force
    
    # Contar arquivos copiados
    $FileCount = (Get-ChildItem -Path $TargetPath -Recurse -File | Measure-Object).Count
    $FolderCount = (Get-ChildItem -Path $TargetPath -Recurse -Directory | Measure-Object).Count
    
    Write-Host ""
    Write-Host "Copia concluida com sucesso!" -ForegroundColor Green
    Write-Host "Estatisticas:" -ForegroundColor Cyan
    Write-Host "   Arquivos copiados: $FileCount" -ForegroundColor White
    Write-Host "   Pastas copiadas: $FolderCount" -ForegroundColor White
    
    # Verificar arquivos principais
    Write-Host ""
    Write-Host "Verificando arquivos principais:" -ForegroundColor Cyan
    
    $MainFiles = @(
        "ContatosLeonidio.application",
        "index.html"
    )
    
    foreach ($file in $MainFiles) {
        $filePath = Join-Path $TargetPath $file
        if (Test-Path $filePath) {
            $size = (Get-Item $filePath).Length
            Write-Host "   OK: $file ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "   ERRO: $file (nao encontrado)" -ForegroundColor Red
        }
    }
    
    # Verificar pasta Application Files
    $AppFilesPath = Join-Path $TargetPath "Application Files"
    if (Test-Path $AppFilesPath) {
        $versions = Get-ChildItem -Path $AppFilesPath -Directory | Sort-Object Name
        Write-Host "   OK: Application Files ($($versions.Count) versoes)" -ForegroundColor Green
        foreach ($version in $versions) {
            Write-Host "      $($version.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ERRO: Application Files (nao encontrado)" -ForegroundColor Red
    }
    
} catch {
    Write-Host ""
    Write-Host "ERRO durante a copia:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "1. Verificar se os arquivos foram copiados corretamente"
Write-Host "2. Executar: git add ."
Write-Host "3. Executar: git commit -m 'update: Republished ClickOnce with correct Vercel URLs'"
Write-Host "4. Executar: git push"

# Perguntar se quer executar os comandos git automaticamente
Write-Host ""
$gitResponse = Read-Host "Deseja executar os comandos git automaticamente? (s/n)"
if ($gitResponse -eq "s" -or $gitResponse -eq "S") {
    Write-Host ""
    Write-Host "Executando comandos git..." -ForegroundColor Blue
    
    Set-Location "e:\CriacaoVS\appsclickonce"
    
    Write-Host "   git add ..." -ForegroundColor Gray
    git add .
    
    Write-Host "   git commit ..." -ForegroundColor Gray
    git commit -m "update: Republished ClickOnce with correct Vercel URLs and hash validation"
    
    Write-Host "   git push ..." -ForegroundColor Gray
    git push
    
    Write-Host ""
    Write-Host "Comandos git executados!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Script concluido! Os arquivos estao prontos para o Vercel." -ForegroundColor Green