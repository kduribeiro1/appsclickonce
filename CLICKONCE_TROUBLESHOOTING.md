# ClickOnce Deployment - Soluções para Erros de Hash

## 🚨 Problema Identificado

**Erro**: "O manifesto do aplicativo possui um hash calculado diferente do especificado ou não possui hash especificado."

### Causa Raiz
O Vercel pode estar comprimindo ou modificando os arquivos ClickOnce durante o deployment, causando divergências nos hashes SHA256 calculados pelo sistema ClickOnce.

---

## ✅ Soluções Implementadas

### 1. **Configuração do vercel.json**
```json
{
  "headers": [
    {
      "source": "/instaladores/(.*)\\.application$",
      "headers": [
        { "key": "Content-Type", "value": "application/x-ms-application" },
        { "key": "Cache-Control", "value": "no-cache, no-store, must-revalidate" },
        { "key": "Content-Encoding", "value": "" }
      ]
    },
    // ... outras configurações
  ],
  "trailingSlash": false,
  "cleanUrls": false
}
```

### 2. **Arquivos Criados**
- `.vercelignore` - Evita processamento desnecessário
- `public/_redirects` - Redirecionamentos específicos

---

## 🔧 Soluções Adicionais

### **Opção 1: Regenerar Manifestos (Recomendado)**
1. **No Visual Studio**, republique a aplicação ClickOnce:
   - Vá em **Publish → Publish Wizard**
   - Altere a **Publishing URL** para: `https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/`
   - **IMPORTANTE**: Certifique-se de que a URL termina com `/`
   - Republique a aplicação

### **Opção 2: Configuração de Assinatura**
```xml
<!-- No arquivo .csproj -->
<PropertyGroup>
  <SignManifests>false</SignManifests>
  <GenerateManifests>true</GenerateManifests>
  <PublishUrl>https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/</PublishUrl>
  <InstallUrl>https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/</InstallUrl>
</PropertyGroup>
```

### **Opção 3: Deploy via GitHub Actions**
Criar um workflow que:
1. Compila a aplicação
2. Gera os manifestos ClickOnce
3. Faz upload para Vercel sem processamento

---

## 🔍 Verificações

### **1. Validar URLs no Manifesto**
O arquivo `ContatosLeonidio.application` deve conter:
```xml
<deploymentProvider codebase="https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application" />
```

### **2. Verificar Content-Type Headers**
```bash
curl -I https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/ContatosLeonidio.application
# Deve retornar: Content-Type: application/x-ms-application
```

### **3. Testar Hash dos Arquivos**
```bash
# Verificar se os arquivos não foram modificados
curl -s https://appsclickonce.vercel.app/instaladores/ContatosLeonidio/Application%20Files/ContatosLeonidio_2_0_0_4/ContatosLeonidio.exe | sha256sum
```

---

## 📋 Checklist de Deploy

- [ ] URLs corretas no manifesto de deployment
- [ ] Headers HTTP configurados corretamente
- [ ] Arquivos não comprimidos pelo Vercel
- [ ] Cache desabilitado para arquivos ClickOnce
- [ ] Estrutura de pastas preservada
- [ ] Manifesto republicado após mudanças de URL

---

## 🛠️ Comandos Úteis

### **Limpar Cache do ClickOnce (Cliente)**
```cmd
rundll32 dfshim.dll,ShArpMaintain_GetTotalSize -appname ContatosLeonidio.exe, Version=2.0.0.4, Culture=pt-BR, PublicKeyToken=0000000000000000, processorArchitecture=msil
```

### **Verificar Logs ClickOnce**
```cmd
# Windows Event Viewer
eventvwr.msc
# Applications and Services Logs → Microsoft → Windows → Application-Experience
```

---

## 🎯 Próximos Passos

1. **Republique a aplicação** no Visual Studio com a URL correta
2. **Teste o deployment** após o upload para Vercel
3. **Monitore os logs** durante a instalação
4. **Considere usar certificados** para aplicações em produção

---

*Última atualização: 13/11/2025*