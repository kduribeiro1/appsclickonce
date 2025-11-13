# Script para copiar arquivos publicados do Visual Studio para o projeto Vercel
# Execute este script após republicar o ContatosLeonidio no Visual Studio

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    [string]$TargetPath = "e:\CriacaoVS\appsclickonce\public\instaladores\ContatosLeonidio"
)

Write-Host "🚀 Iniciando cópia dos arquivos publicados..." -ForegroundColor Green
Write-Host ""

# Verificar se o diretório de origem existe
if (!(Test-Path $SourcePath)) {
    Write-Host "❌ ERRO: Diretório de origem não encontrado: $SourcePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "📝 Como usar este script:" -ForegroundColor Yellow
    Write-Host "1. Republique o projeto ContatosLeonidio no Visual Studio"
    Write-Host "2. Anote o caminho onde os arquivos foram publicados"
    Write-Host "3. Execute: .\copy_published_files.ps1 -SourcePath 'CAMINHO_DA_PUBLICACAO'"
    Write-Host ""
    Write-Host "Exemplo:"
    Write-Host ".\copy_published_files.ps1 -SourcePath 'C:\Publish\ContatosLeonidio'"
    exit 1
}

# Criar backup do diretório atual
$BackupPath = "$TargetPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (Test-Path $TargetPath) {
    Write-Host "📦 Criando backup em: $BackupPath" -ForegroundColor Blue
    Copy-Item -Path $TargetPath -Destination $BackupPath -Recurse -Force
}

# Remover diretório atual se existir
if (Test-Path $TargetPath) {
    Write-Host "🗑️  Removendo arquivos antigos..." -ForegroundColor Yellow
    Remove-Item -Path $TargetPath -Recurse -Force
}

# Criar diretório de destino
Write-Host "📁 Criando diretório de destino..." -ForegroundColor Blue
New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null

# Copiar todos os arquivos
Write-Host "📋 Copiando arquivos de $SourcePath para $TargetPath..." -ForegroundColor Blue
try {
    Copy-Item -Path "$SourcePath\*" -Destination $TargetPath -Recurse -Force
    
    # Contar arquivos copiados
    $FileCount = (Get-ChildItem -Path $TargetPath -Recurse -File | Measure-Object).Count
    $FolderCount = (Get-ChildItem -Path $TargetPath -Recurse -Directory | Measure-Object).Count
    
    Write-Host ""
    Write-Host "✅ Cópia concluída com sucesso!" -ForegroundColor Green
    Write-Host "📊 Estatísticas:" -ForegroundColor Cyan
    Write-Host "   • Arquivos copiados: $FileCount" -ForegroundColor White
    Write-Host "   • Pastas copiadas: $FolderCount" -ForegroundColor White
    
    # Verificar arquivos principais
    Write-Host ""
    Write-Host "🔍 Verificando arquivos principais:" -ForegroundColor Cyan
    
    $MainFiles = @(
        "ContatosLeonidio.application",
        "index.html"
    )
    
    foreach ($file in $MainFiles) {
        $filePath = Join-Path $TargetPath $file
        if (Test-Path $filePath) {
            $size = (Get-Item $filePath).Length
            Write-Host "   ✅ $file ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $file (não encontrado)" -ForegroundColor Red
        }
    }
    
    # Verificar pasta Application Files
    $AppFilesPath = Join-Path $TargetPath "Application Files"
    if (Test-Path $AppFilesPath) {
        $versions = Get-ChildItem -Path $AppFilesPath -Directory | Sort-Object Name
        Write-Host "   ✅ Application Files ($($versions.Count) versões)" -ForegroundColor Green
        foreach ($version in $versions) {
            Write-Host "      • $($version.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ❌ Application Files (não encontrado)" -ForegroundColor Red
    }
    
} catch {
    Write-Host ""
    Write-Host "❌ ERRO durante a cópia:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📝 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Verificar se os arquivos foram copiados corretamente"
Write-Host "2. Executar: git add ."
Write-Host "3. Executar: git commit -m 'update: Republished ClickOnce with correct Vercel URLs'"
Write-Host "4. Executar: git push"
Write-Host ""
Write-Host "🎯 Após o push, teste novamente: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application"

# Perguntar se quer executar os comandos git automaticamente
Write-Host ""
$gitResponse = Read-Host "Deseja executar os comandos git automaticamente? (s/n)"
if ($gitResponse -eq "s" -or $gitResponse -eq "S") {
    Write-Host ""
    Write-Host "🔄 Executando comandos git..." -ForegroundColor Blue
    
    Set-Location "e:\CriacaoVS\appsclickonce"
    
    Write-Host "   git add ..." -ForegroundColor Gray
    git add .
    
    Write-Host "   git commit ..." -ForegroundColor Gray
    git commit -m "update: Republished ClickOnce with correct Vercel URLs and hash validation"
    
    Write-Host "   git push ..." -ForegroundColor Gray
    git push
    
    Write-Host ""
    Write-Host "✅ Comandos git executados!" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Script concluído! Os arquivos estão prontos para o Vercel." -ForegroundColor Green