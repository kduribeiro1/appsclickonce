# Script para migrar ClickOnce do Vercel para GitHub Pages

Write-Host "=== MIGRACAO CLICKONCE: VERCEL -> GITHUB PAGES ===" -ForegroundColor Green
Write-Host ""

# URLs
$githubPagesUrl = "https://kduribeiro1.github.io/appsclickonce"
$vercelUrl = "https://appsclickonce.vercel.app"

Write-Host "Configurando migracao para GitHub Pages..." -ForegroundColor Cyan
Write-Host "URL do GitHub Pages: $githubPagesUrl" -ForegroundColor Yellow
Write-Host ""

# Verificar se o GitHub Actions workflow foi criado
if (!(Test-Path ".github\workflows\pages.yml")) {
    Write-Host "ERRO: Arquivo .github\workflows\pages.yml nao encontrado!" -ForegroundColor Red
    exit 1
}

Write-Host "GitHub Actions workflow configurado!" -ForegroundColor Green

# Instruções para republicar no Visual Studio
Write-Host ""
Write-Host "=== INSTRUCOES PARA REPUBLICAR NO VISUAL STUDIO ===" -ForegroundColor Green
Write-Host ""
Write-Host "1. Abrir Visual Studio e o projeto ContatosLeonidio" -ForegroundColor White
Write-Host "2. Ir em Project -> Publish ContatosLeonidio" -ForegroundColor White
Write-Host "3. Configurar as URLs:" -ForegroundColor White
Write-Host "   Publishing Folder: $githubPagesUrl/instaladores/ContatosLeonidio/" -ForegroundColor Yellow
Write-Host "   Installation URL:  $githubPagesUrl/instaladores/ContatosLeonidio/" -ForegroundColor Yellow
Write-Host "4. Clicar 'Publish'" -ForegroundColor White
Write-Host "5. Copiar arquivos usando o script copy_files_simple.ps1" -ForegroundColor White
Write-Host ""

# Verificar repositório Git
$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl -match "github\.com[/:]([^/]+)/([^/]+)") {
    $owner = $matches[1]
    $repo = $matches[2] -replace "\.git$", ""
    Write-Host "Repositorio detectado: $owner/$repo" -ForegroundColor Green
} else {
    Write-Host "AVISO: Nao foi possivel detectar o repositorio GitHub" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== PROXIMOS PASSOS ===" -ForegroundColor Green
Write-Host ""
Write-Host "1. Fazer commit e push deste workflow:" -ForegroundColor White
Write-Host "   git add .github/workflows/pages.yml" -ForegroundColor Gray
Write-Host "   git commit -m 'feat: Add GitHub Pages deployment'" -ForegroundColor Gray
Write-Host "   git push" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Habilitar GitHub Pages no repositorio:" -ForegroundColor White
Write-Host "   - Ir em Settings -> Pages" -ForegroundColor Gray
Write-Host "   - Source: GitHub Actions" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Republicar no Visual Studio com URLs do GitHub Pages" -ForegroundColor White
Write-Host ""
Write-Host "4. Usar o script de copia:" -ForegroundColor White
Write-Host "   .\copy_files_simple.ps1 -SourcePath 'CAMINHO_DA_PUBLICACAO'" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Commit e push dos arquivos atualizados" -ForegroundColor White
Write-Host ""

# Perguntar se quer fazer o commit agora
Write-Host "Deseja fazer commit e push do GitHub Actions workflow agora? (s/n): " -NoNewline -ForegroundColor Yellow
$response = Read-Host

if ($response -eq "s" -or $response -eq "S") {
    Write-Host ""
    Write-Host "Fazendo commit do workflow..." -ForegroundColor Blue
    
    git add .github/workflows/pages.yml
    git commit -m "feat: Add GitHub Pages deployment workflow for ClickOnce"
    git push
    
    Write-Host ""
    Write-Host "SUCESSO! Workflow enviado para GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Agora va em:" -ForegroundColor Yellow
    Write-Host "https://github.com/$owner/$repo/settings/pages" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "E configure:" -ForegroundColor Yellow
    Write-Host "Source: GitHub Actions" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "OK, faca o commit manualmente quando estiver pronto." -ForegroundColor Blue
}

Write-Host ""
Write-Host "=== VANTAGENS DO GITHUB PAGES ===" -ForegroundColor Green
Write-Host "- Arquivos servidos sem modificacao" -ForegroundColor White
Write-Host "- Headers HTTP adequados para ClickOnce" -ForegroundColor White
Write-Host "- Deploy automatico via GitHub Actions" -ForegroundColor White
Write-Host "- Gratuito e confiavel" -ForegroundColor White
Write-Host "- Sem problemas de hash validation" -ForegroundColor White