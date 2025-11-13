# 🚀 Guia Rápido - Republicar ClickOnce para Vercel

## 📋 Passo a Passo Completo

### 1️⃣ Republicar no Visual Studio

1. **Abrir Visual Studio**
2. **Abrir o projeto ContatosLeonidio** 
3. **Clicar com botão direito no projeto → Properties**
4. **Ir na aba "Publish"** ou usar menu **Project → Publish ContatosLeonidio**
5. **Configurar URLs**:
   ```
   Publishing Folder Location: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/
   Installation Folder URL: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/
   ```
6. **Clicar "Publish Now"**
7. **Anotar o caminho onde foi publicado** (ex: `C:\Publish\ContatosLeonidio`)

### 2️⃣ Copiar Arquivos com Script Automático

No PowerShell, execute:

```powershell
cd "e:\CriacaoVS\appsclickonce"
.\copy_published_files.ps1 -SourcePath "CAMINHO_ONDE_FOI_PUBLICADO"
```

**Exemplo:**
```powershell
.\copy_published_files.ps1 -SourcePath "C:\Publish\ContatosLeonidio"
```

### 3️⃣ O Script Vai Fazer Automaticamente:

✅ Criar backup dos arquivos atuais  
✅ Copiar todos os novos arquivos  
✅ Verificar se os arquivos principais existem  
✅ Mostrar estatísticas da cópia  
✅ Perguntar se quer executar git add/commit/push automaticamente  

### 4️⃣ Verificar Resultado

Após o deploy no Vercel, teste:
```
https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application
```

## 🔧 Solução de Problemas

### Se o script não encontrar os arquivos:
```powershell
# Verifique onde o Visual Studio publicou:
Get-ChildItem -Path "C:\Users\$env:USERNAME\Desktop" -Filter "*.application" -Recurse
```

### Se precisar copiar manualmente:
```powershell
# Substitua CAMINHO_PUBLICACAO pelo caminho real:
Copy-Item -Path "CAMINHO_PUBLICACAO\*" -Destination "e:\CriacaoVS\appsclickonce\public\instaladores\ContatosLeonidio" -Recurse -Force
```

### Para verificar se funcionou:
```powershell
# Verificar se o arquivo principal existe:
Test-Path "e:\CriacaoVS\appsclickonce\public\instaladores\ContatosLeonidio\ContatosLeonidio.application"
```

## 🎯 Por Que Isso Resolve o Problema

1. **Hashes Corretos**: O Visual Studio irá gerar hashes SHA256 corretos para as URLs do Vercel
2. **URLs Corretas**: Os manifestos terão as URLs `https://appsclickonce.vercel.app/` 
3. **Validação**: Os hashes nos manifestos corresponderão aos arquivos reais

## 📝 Comandos Git Manuais (se não usar o script automático):

```powershell
cd "e:\CriacaoVS\appsclickonce"
git add .
git commit -m "update: Republished ClickOnce with correct Vercel URLs and hash validation"
git push
```

---

**🎉 Após seguir esses passos, o ClickOnce deve funcionar perfeitamente no Vercel!**