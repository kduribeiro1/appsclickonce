#!/bin/bash

# Script para Regenerar Manifestos ClickOnce com Hashes Corretos

echo "🔧 Regenerando manifestos ClickOnce..."

# Diretório do projeto ClickOnce
CLICKONCE_DIR="public/instaladores/ContatosLeonidio/Application Files/ContatosLeonidio_2_0_0_4"

# Verificar se o diretório existe
if [ ! -d "$CLICKONCE_DIR" ]; then
    echo "❌ Erro: Diretório $CLICKONCE_DIR não encontrado!"
    exit 1
fi

echo "📁 Processando arquivos em: $CLICKONCE_DIR"

# Listar todos os arquivos .deploy
echo "📋 Arquivos .deploy encontrados:"
find "$CLICKONCE_DIR" -name "*.deploy" | head -10

# Calcular novos hashes SHA256 para arquivos principais
echo "🔄 Calculando novos hashes..."

# Função para calcular hash SHA256 em base64
calculate_hash() {
    local file="$1"
    if [ -f "$file" ]; then
        # No Windows com PowerShell
        if command -v powershell.exe &> /dev/null; then
            powershell.exe -Command "(Get-FileHash -Algorithm SHA256 '$file').Hash | ForEach-Object { [Convert]::ToBase64String([byte[]] -split (\$_ -replace '..', '0x$&,')) }"
        else
            # No Linux/Mac
            openssl dgst -sha256 -binary "$file" | base64
        fi
    else
        echo "Arquivo não encontrado: $file"
    fi
}

# Calcular hashes dos arquivos principais
echo "📊 Hashes dos arquivos principais:"
echo "ContatosLeonidio.exe: $(calculate_hash "$CLICKONCE_DIR/ContatosLeonidio.exe")"
echo "ContatosLeonidio.dll: $(calculate_hash "$CLICKONCE_DIR/ContatosLeonidio.dll")"
echo "Launcher.exe: $(calculate_hash "$CLICKONCE_DIR/Launcher.exe")"

echo "✅ Script concluído!"
echo ""
echo "🚨 AÇÃO NECESSÁRIA:"
echo "1. Execute este script no Visual Studio para republicar:"
echo "   - Build → Publish → ContatosLeonidio"
echo "   - Defina a Publishing URL como: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/"
echo "   - Republique a aplicação"
echo ""
echo "2. Ou use o comando MageUI.exe para atualizar os manifestos manualmente"