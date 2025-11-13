# 🚨 SOLUÇÃO DEFINITIVA - Erro de Hash ClickOnce

## ❌ **Problema Atual:**
```
O arquivo ContatosLeonidio.exe.manifest possui um hash calculado diferente do especificado no manifesto.
```

## 🎯 **Causa Raiz:**
O Vercel pode estar alterando os arquivos binários durante o upload/processamento, causando divergência nos hashes SHA256.

---

## ✅ **SOLUÇÃO DEFINITIVA - Método 1: Republicar no Visual Studio**

### **Passo 1: Configurar URLs no Visual Studio**
1. Abra o **Visual Studio**
2. Abra o projeto **ContatosLeonidio**
3. Clique com o botão direito no projeto → **Properties**
4. Vá para a aba **Publish**
5. Configure:
   ```
   Publishing Folder Location: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/
   Installation Folder URL: https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/
   ```

### **Passo 2: Configurações de Segurança**
Na aba **Publish**, clique em **Options** e configure:
- ✅ **Enable ClickOnce Security Settings: NO** (desmarcar)
- ✅ **Sign the Manifests: NO** (desmarcar)
- ✅ **Enable URL Parameters: NO** (desmarcar)

### **Passo 3: Republicar**
1. Clique em **Publish Now**
2. Aguarde a compilação
3. **SUBSTITUA** todos os arquivos em `public/instaladores/ContatosLeonidio/` pelos novos gerados

---

## ✅ **SOLUÇÃO DEFINITIVA - Método 2: MageUI.exe (Manual)**

### **Pré-requisitos:**
- Windows SDK instalado
- MageUI.exe disponível

### **Passos:**
```powershell
# 1. Execute o script para calcular novos hashes
.\regenerate_hashes.ps1

# 2. Abra o MageUI.exe
MageUI.exe

# 3. Abra o manifesto de deployment:
# File → Open → ContatosLeonidio.application

# 4. Vá para Application Reference tab
# 5. Atualize o hash do ContatosLeonidio.dll.manifest

# 6. Salve o manifesto atualizado
```

---

## 🔧 **SOLUÇÃO DEFINITIVA - Método 3: Desabilitar Validação de Hash**

### **Modificar o Manifesto de Deployment:**
Edite `ContatosLeonidio.application` e adicione:

```xml
<deployment install="true" mapFileExtensions="true" minimumRequiredVersion="2.0.0.4" 
            co.v1:createDesktopShortcut="true" trustURLParameters="false">
    <subscription>
        <update>
            <beforeApplicationStartup />
        </update>
    </subscription>
    <deploymentProvider codebase="https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application" />
</deployment>
```

### **Modificar o Manifesto da Aplicação:**
Remova as seções `<hash>` dos arquivos em `ContatosLeonidio.dll.manifest`:

```xml
<!-- REMOVER estas seções -->
<hash>
    <dsig:Transforms>
        <dsig:Transform Algorithm="urn:schemas-microsoft-com:HashTransforms.Identity" />
    </dsig:Transforms>
    <dsig:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha256" />
    <dsig:DigestValue>HASH_VALUE_HERE</dsig:DigestValue>
</hash>
```

---

## 📋 **CHECKLIST - Execute em Ordem:**

### **Fase 1: Preparação**
- [ ] Execute `regenerate_hashes.ps1` para verificar arquivos
- [ ] Faça backup dos manifestos atuais
- [ ] Verifique se o Visual Studio está instalado

### **Fase 2: Republicação**
- [ ] Configure URLs corretas no Visual Studio
- [ ] Desabilite assinatura de manifestos
- [ ] Republique a aplicação
- [ ] Substitua arquivos em `public/instaladores/ContatosLeonidio/`

### **Fase 3: Deploy**
- [ ] Commit das mudanças: `git add . && git commit -m "fix: Update ClickOnce manifests with correct hashes"`
- [ ] Push: `git push origin main`
- [ ] Aguarde deploy do Vercel
- [ ] Teste instalação ClickOnce

### **Fase 4: Verificação**
- [ ] Acesse: `https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application`
- [ ] Teste instalação completa
- [ ] Verifique se não há mais erros de hash

---

## 🎯 **ALTERNATIVA RÁPIDA - GitHub Actions Deploy**

Se o problema persistir, podemos configurar um GitHub Action que:

1. Compila a aplicação ClickOnce
2. Calcula hashes corretos
3. Faz upload direto para Vercel
4. Evita qualquer processamento intermediário

---

## ⚡ **COMANDO RÁPIDO:**

```powershell
# Execute este comando para iniciar o processo:
.\regenerate_hashes.ps1

# Em seguida, republique no Visual Studio com as URLs corretas
```

---

**🎯 RECOMENDAÇÃO: Use o Método 1 (Visual Studio) primeiro, é o mais confiável!**

*Após republicar, o erro de hash será completamente resolvido.*