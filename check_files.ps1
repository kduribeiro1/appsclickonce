# Script PowerShell Simplificado para ClickOnce

Write-Host "Verificando arquivos ClickOnce..." -ForegroundColor Green

$ClickOnceDir = "public\instaladores\ContatosLeonidio\Application Files\ContatosLeonidio_2_0_0_4"

if (Test-Path $ClickOnceDir) {
    Write-Host "Diretorio encontrado: $ClickOnceDir" -ForegroundColor Yellow
    
    # Listar alguns arquivos principais
    $files = @("ContatosLeonidio.exe", "ContatosLeonidio.dll", "Launcher.exe")
    
    foreach ($file in $files) {
        $fullPath = Join-Path $ClickOnceDir $file
        if (Test-Path $fullPath) {
            $size = (Get-Item $fullPath).Length
            Write-Host "$file - Tamanho: $size bytes" -ForegroundColor White
        } else {
            Write-Host "$file - NAO ENCONTRADO" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Diretorio nao encontrado: $ClickOnceDir" -ForegroundColor Red
}

Write-Host ""
Write-Host "SOLUCAO RECOMENDADA:" -ForegroundColor Yellow
Write-Host "1. Abra o Visual Studio" -ForegroundColor White
Write-Host "2. Republique o projeto ContatosLeonidio" -ForegroundColor White
Write-Host "3. Configure a URL de publicacao como:" -ForegroundColor White
Write-Host "   https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/" -ForegroundColor Cyan
Write-Host "4. Substitua os arquivos gerados na pasta public/instaladores/ContatosLeonidio/" -ForegroundColor White