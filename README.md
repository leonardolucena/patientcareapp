# PatientCare App

Aplicativo de gerenciamento de cuidados com pacientes.

## 🚀 Estrutura do Projeto

```
lib/
├── main.dart                      # Ponto de entrada da aplicação
├── routes/
│   └── app_router.dart           # Configuração de rotas com GoRouter
└── screens/
    ├── login_screen.dart         # Tela de login
    └── search_clinics_screen.dart # Tela de busca de clínicas com mapa
```

## 📦 Dependências Principais

- **Flutter SDK**: ^3.6.1
- **go_router**: ^14.6.2 - Gerenciamento de rotas
- **google_maps_flutter**: ^2.9.0 - Integração com Google Maps

## 🏃 Como Executar

### Pré-requisitos

1. **Configurar API Key do Google Maps** (obrigatório)
   - Siga as instruções detalhadas no arquivo: [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)
   - Configure a API Key no Android (`android/app/src/main/AndroidManifest.xml`)
   - Configure a API Key no iOS (`ios/Runner/AppDelegate.swift`)

### Executar o projeto

```bash
# Instalar dependências
flutter pub get

# Executar no emulador/dispositivo
flutter run

# Build para Android
flutter build apk

# Build para iOS
flutter build ios
```

## 🎨 Funcionalidades Implementadas

- ✅ Tela de login (navega direto ao clicar em entrar)
- ✅ Tela de busca de clínicas com Google Maps
- ✅ Gerenciamento de rotas com GoRouter
- ✅ Design moderno e responsivo
- ✅ Tema Material 3
- ✅ Integração com Google Maps
- ✅ Permissões de localização configuradas (Android/iOS)

## 📝 Próximas Funcionalidades

- [ ] Implementar busca real de clínicas
- [ ] Adicionar marcadores dinâmicos no mapa
- [ ] Implementar autenticação real
- [ ] Adicionar tela de cadastro
- [ ] Implementar recuperação de senha
- [ ] Adicionar detalhes da clínica
- [ ] Implementar agendamento de consultas
- [ ] Implementar gerenciamento de estado

## 🔧 Configurações

O projeto está configurado para as plataformas:
- Android
- iOS
