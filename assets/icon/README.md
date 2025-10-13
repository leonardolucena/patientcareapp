# 🎨 Ícone e Splash Screen do PatientCare App

Este diretório contém os assets para o ícone do aplicativo e splash screen.

## 📁 Arquivos

- **icon.svg** - Ícone vetorial original (cruz de hospital em teal)
- **icon.png** - Ícone PNG 1024x1024 gerado a partir do SVG
- **generate_icon.py** - Script Python para gerar ícone (requer Pillow)
- **create_icon.sh** - Script shell para converter SVG para PNG

## 🎨 Design

O ícone utiliza:
- **Símbolo**: Cruz de hospital (medical cross)
- **Cor Principal**: Teal (#3F7884) - mesma cor do app
- **Fundo**: Branco (#FFFFFF)
- **Estilo**: Minimalista e moderno

## 🔧 Como Atualizar

### 1. Editar o Ícone

Edite o arquivo `icon.svg` com qualquer editor de SVG (Figma, Adobe Illustrator, Inkscape, etc.)

### 2. Gerar PNG

```bash
# Opção 1: Usar o script (macOS)
./create_icon.sh

# Opção 2: Manual com ImageMagick
brew install imagemagick
convert icon.svg -resize 1024x1024 icon.png

# Opção 3: Usar ferramenta online
# https://cloudconvert.com/svg-to-png
```

### 3. Gerar Assets do App

```bash
# Gerar ícones do launcher
dart run flutter_launcher_icons

# Gerar splash screen
dart run flutter_native_splash:create
```

## 📱 Plataformas Suportadas

- ✅ **Android** - Ícone padrão e adaptativo
- ✅ **iOS** - Todos os tamanhos de ícone
- ✅ **Splash Screen** - Android (incluindo Android 12+) e iOS

## 🎯 Especificações

### Ícone
- **Tamanho base**: 1024x1024 px
- **Formato**: PNG com fundo branco
- **Cantos**: Arredondados no iOS (automático)

### Splash Screen
- **Fundo**: Branco (#FFFFFF)
- **Imagem**: Centralizada, mesmo ícone do launcher
- **Modo iOS**: Center (mantém proporções)

## 📝 Configuração

A configuração está em `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/icon.png"

flutter_native_splash:
  color: "#FFFFFF"
  image: assets/icon/icon.png
  android: true
  ios: true
```

---

**PatientCare** - Ícone criado com ❤️

