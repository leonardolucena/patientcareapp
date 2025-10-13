# Changelog - PatientCare App

## [0.2.0] - 2025-10-13

### ✨ Novas Funcionalidades

#### Tela de Busca de Clínicas
- ✅ Criada tela de busca com Google Maps integrado
- ✅ Campo de busca para pesquisar clínicas
- ✅ Mapa interativo com zoom e controles
- ✅ Marcador de exemplo no mapa
- ✅ Design responsivo com padding de 24px

#### Navegação
- ✅ Login agora navega direto para a tela de busca (sem validação)
- ✅ Rota `/search-clinics` adicionada ao GoRouter
- ✅ Navegação suave entre telas

### 🔧 Configurações

#### Android
- ✅ Permissões de localização adicionadas
- ✅ Permissões de internet configuradas
- ✅ Meta-data para Google Maps API Key
- ✅ AndroidManifest.xml atualizado

#### iOS
- ✅ Permissões de localização (NSLocationWhenInUseUsageDescription)
- ✅ Permissões de localização sempre (NSLocationAlwaysAndWhenInUseUsageDescription)
- ✅ Embedded views habilitado para Maps
- ✅ AppDelegate.swift configurado com GMSServices
- ✅ Info.plist atualizado

### 📦 Dependências Adicionadas
- `google_maps_flutter: ^2.9.0`

### 📚 Documentação
- ✅ Criado `GOOGLE_MAPS_SETUP.md` com instruções detalhadas
- ✅ README.md atualizado com novas funcionalidades
- ✅ .gitignore atualizado para proteger API Keys

### 🎨 Interface
- Layout limpo e moderno
- Título "Procure sua clínica"
- Campo de busca com ícone
- Mapa ocupando o restante da tela
- Padding consistente (24px)

---

## [0.1.0] - 2025-10-13

### ✨ Funcionalidades Iniciais
- Tela de login com validação
- Configuração inicial do projeto Flutter
- GoRouter para gerenciamento de rotas
- Tema Material 3 customizado
- Estrutura de pastas organizada

