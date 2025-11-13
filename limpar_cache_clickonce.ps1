# Script para limpar cache do ClickOnce
Write-Host "Limpando cache do ClickOnce..." -ForegroundColor Yellow

try {
    # Método 1: rundll32
    Write-Host "Executando limpeza via rundll32..." -ForegroundColor Cyan
    & rundll32 dfshim CleanOnlineAppCache
    
    # Método 2: Pasta de cache local
    $cacheFolder = "$env:LOCALAPPDATA\Apps\2.0"
    if (Test-Path $cacheFolder) {
        Write-Host "Removendo pasta de cache: $cacheFolder" -ForegroundColor Cyan
        Remove-Item $cacheFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cache local removido com sucesso!" -ForegroundColor Green
    }
    
    # Método 3: Registros do ClickOnce
    $regPaths = @(
        "HKCU:\Software\Classes\Software\Microsoft\Windows\CurrentVersion\Deployment\SideBySide",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    )
    
    foreach ($regPath in $regPaths) {
        if (Test-Path $regPath) {
            Write-Host "Limpando registro: $regPath" -ForegroundColor Cyan
            Get-ChildItem $regPath -ErrorAction SilentlyContinue | 
                Where-Object { $_.Name -like "*ContatosLeonidio*" } | 
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    # Método 4: Cache de download
    $downloadCache = "$env:USERPROFILE\Local Settings\Apps\2.0"
    if (Test-Path $downloadCache) {
        Write-Host "Removendo cache de download: $downloadCache" -ForegroundColor Cyan
        Remove-Item $downloadCache -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "`nCache do ClickOnce limpo com sucesso!" -ForegroundColor Green
    Write-Host "Agora tente instalar a aplicação novamente." -ForegroundColor Yellow
    
} catch {
    Write-Host "Erro ao limpar cache: $_" -ForegroundColor Red
}

Write-Host "`nPressione qualquer tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")