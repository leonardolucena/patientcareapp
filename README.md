# PatientCare App 🏥

Aplicativo Flutter para gerenciamento de consultas médicas e cuidados com pacientes. O app permite buscar clínicas, visualizar perfis de médicos, agendar consultas e muito mais!

## 📱 Screenshots

<div align="center">

### 🔐 Login
<p>
  <img src="assets/screenshots/login/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.27.04.png" width="250" alt="Login Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/login/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.27.07.png" width="250" alt="Login Dark"/>
</p>

### 🔍 Busca de Clínicas
<p>
  <img src="assets/screenshots/busca/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.27.32.png" width="250" alt="Busca Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/busca/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.27.41.png" width="250" alt="Busca Dark"/>
</p>

### 📍 Modal Clínica
<p>
  <img src="assets/screenshots/modal_confirmar_clinica/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.28.16.png" width="250" alt="Modal Clínica Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/modal_confirmar_clinica/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.28.26.png" width="250" alt="Modal Clínica Dark"/>
</p>

### 👨‍⚕️ Lista de Médicos
<p>
  <img src="assets/screenshots/clinica/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.29.18.png" width="250" alt="Lista Médicos Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/clinica/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.29.33.png" width="250" alt="Lista Médicos Dark"/>
</p>

### 📋 Perfil do Médico
<p>
  <img src="assets/screenshots/medico/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.30.17.png" width="250" alt="Perfil Médico Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/medico/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.30.34.png" width="250" alt="Perfil Médico Dark"/>
</p>

### 📅 Modal Agendar Consulta - Parte 1
<p>
  <img src="assets/screenshots/modal_agendar_consulta/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.31.57.png" width="250" alt="Agendar Parte 1 Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/modal_agendar_consulta/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.32.02.png" width="250" alt="Agendar Parte 1 Dark"/>
</p>

### 📅 Modal Agendar Consulta - Parte 2
<p>
  <img src="assets/screenshots/modal_agendar_consulta/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.32.26.png" width="250" alt="Agendar Parte 2 Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/modal_agendar_consulta/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.32.30.png" width="250" alt="Agendar Parte 2 Dark"/>
</p>

### ✅ Confirmação de Agendamento
<p>
  <img src="assets/screenshots/confirmacao_agendamento/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.33.32.png" width="250" alt="Confirmação Light"/>
  &nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/confirmacao_agendamento/Simulator Screenshot - iPhone 16 Plus - 2025-10-13 at 08.33.58.png" width="250" alt="Confirmação Dark"/>
</p>

</div>

---

## ✨ Funcionalidades

### 🔐 Autenticação
- **Tela de Login**: Interface moderna com validação de formulário
- **Alternância de Tema**: Botão para alternar entre light e dark mode
- **Seletor de Idioma**: Menu para escolher entre Português 🇧🇷 e English 🇺🇸
- **Logout**: Botão de logout com confirmação em todas as telas principais

### 🏥 Busca de Clínicas
- **Mapa Fictício**: Visualização interativa com marcadores de clínicas
- **Lista de Clínicas**: Cards com informações de distância e localização
- **Detalhes da Clínica**: Bottom sheet com endereço e botão de agendamento

### 👨‍⚕️ Médicos
- **Banner Informativo**: Destaque visual com chamada para ação
- **Filtro por Especialidade**: 8+ especialidades médicas (Cardiologia, Dermatologia, Pediatria, etc.)
- **Busca por Nome**: Campo de busca dinâmico
- **Lista de Médicos**: Cards com foto, nome, especialidade, experiência, avaliação e preço
- **Scroll Otimizado**: Lista rolável independente mantendo filtros fixos

### 📋 Perfil do Médico
- **Informações Completas**: Nome, especialidades, avaliação e foto
- **Estatísticas**: Número de pacientes, anos de experiência e país
- **Localização**: Mapa fictício com endereço
- **Avaliações**: Sistema de reviews com barras de progresso e comentários
- **Valor da Consulta**: Exibido no rodapé fixo

### 📅 Agendamento de Consulta
- **Bottom Sheet em 2 Páginas**: Navegação fluida entre etapas
- **Página 1**:
  - Tipo de consulta (Online/Presencial)
  - Seletor de dia (scroll horizontal com dias desabilitados)
  - Seletor de horário (8h às 12h)
- **Página 2**:
  - Resumo do agendamento
  - Prioridade (Normal/Urgência)
  - Método de pagamento (Dinheiro/Cartão de crédito)
- **Validação**: Desabilita botão "Continuar" se campos não preenchidos

### ✅ Confirmação
- **Tela de Sucesso**: Feedback visual com ícone de confirmação
- **Detalhes do Agendamento**: Todas as informações selecionadas
- **Navegação**: Botão para retornar à busca de clínicas

### 🎨 Design System
- **Paleta de Cores Personalizada**: 6 cores principais com variações para light/dark mode
- **Tema Adaptativo**: Suporte completo a light e dark mode
- **Status Bar Inteligente**: Ícones mudam de cor automaticamente conforme o tema
- **Material Design 3**: Componentes modernos e consistentes
- **Animações**: Transições suaves entre temas
- **Responsividade**: Adaptado para diferentes tamanhos de tela

### 🌐 Internacionalização (i18n)
- **Suporte a Múltiplos Idiomas**: Português (BR) e English (US)
- **Alternância em Tempo Real**: Mudança de idioma sem reiniciar o app
- **Todas as Telas Traduzidas**: 100% do conteúdo disponível em ambos os idiomas
- **Especialidades Traduzidas**: Nomes de especialidades médicas localizados
- **Provider Pattern**: Gerenciamento de estado para idioma selecionado

## 🏗️ Arquitetura SOLID

O projeto segue os princípios **SOLID** e **Clean Architecture** com separação clara em camadas:

```
lib/
├── main.dart                           # Ponto de entrada
├── core/                               # Funcionalidades compartilhadas
│   ├── constants/                      # Constantes da aplicação
│   ├── services/                       # Serviços utilitários
│   ├── utils/                          # Helpers e formatadores
│   └── di/                             # Dependency Injection (GetIt)
├── data/                               # Camada de Dados
│   ├── models/                         # Models (DTOs)
│   ├── datasources/                    # Fontes de dados (local/API)
│   └── repositories/                   # Implementações de repositórios
├── domain/                             # Camada de Domínio (Regras de Negócio)
│   ├── repositories/                   # Contratos (interfaces abstratas)
│   └── usecases/                       # Casos de uso
├── presentation/                       # Camada de Apresentação (UI)
│   ├── providers/                      # State management (ChangeNotifier)
│   ├── screens/                        # Telas da aplicação
│   └── widgets/                        # Widgets reutilizáveis
├── providers/                          # Providers globais
│   └── locale_provider.dart
├── routes/
│   └── app_router.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── theme_provider.dart
│   └── README.md
└── l10n/
    ├── app_pt.arb
    ├── app_en.arb
    └── README.md
```

### 📐 Princípios SOLID Aplicados:

- ✅ **S**ingle Responsibility: Cada classe tem uma única responsabilidade
- ✅ **O**pen/Closed: Aberto para extensão, fechado para modificação
- ✅ **L**iskov Substitution: Use Cases funcionam com qualquer implementação de Repository
- ✅ **I**nterface Segregation: Interfaces específicas e focadas
- ✅ **D**ependency Inversion: Dependências injetadas via GetIt

📚 **[Documentação Completa da Arquitetura](docs/ARCHITECTURE.md)**

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:      # Suporte a localização
    sdk: flutter
  intl: any                   # Internacionalização
  cupertino_icons: ^1.0.8
  go_router: ^14.6.2          # Gerenciamento de rotas
  provider: ^6.1.2            # Gerenciamento de estado
  get_it: ^7.6.4              # Dependency Injection (Service Locator)
```

## 🎨 Paleta de Cores

O app utiliza uma paleta customizada com as seguintes cores principais:

| Cor | Hex | Uso |
|-----|-----|-----|
| Primary Dark | `#05151A` | Backgrounds escuros |
| Primary Teal | `#3F7884` | **Cor principal do app** |
| Primary Teal Dark | `#0C7076` | Acentos e destaques |
| Primary Blue | `#0706FC` | Ações secundárias |
| Primary Cyan | `#6DA6C0` | Complementar |
| Primary Navy | `#294D61` | Textos e elementos |

Cada cor possui variações para light e dark mode, garantindo contraste e legibilidade em ambos os temas.

## 🏃 Como Executar

### Pré-requisitos

- Flutter SDK 3.6.1 ou superior
- Dart 3.0.0 ou superior
- Android Studio / Xcode (para desenvolvimento mobile)

### Instalação

```bash
# Clone o repositório
git clone [url-do-repositorio]

# Entre na pasta do projeto
cd patientcareapp

# Instalar dependências
flutter pub get

# Executar no emulador/dispositivo
flutter run
```

### Build para produção

```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🛠️ Tecnologias e Conceitos Utilizados

### Arquitetura e Padrões
- **Clean Architecture**: Separação em camadas (data, domain, presentation, core)
- **SOLID Principles**: Código manutenível e escalável
- **Dependency Injection**: GetIt como Service Locator
- **Repository Pattern**: Abstração de fontes de dados
- **Use Cases**: Encapsulamento de lógica de negócio
- **Provider Pattern**: Gerenciamento de estado reativo

### Framework e UI
- **Flutter**: Framework multiplataforma
- **Dart**: Linguagem de programação
- **Material Design 3**: Sistema de design
- **Custom Themes**: Sistema de cores e temas personalizados
- **System UI Overlay**: Controle da status bar adaptável ao tema
- **Responsive Design**: Layout adaptável

### Navegação e Estado
- **GoRouter**: Navegação declarativa com rotas nomeadas
- **Provider**: Gerenciamento de estado para tema, idioma e features

### Internacionalização
- **flutter_localizations**: Suporte oficial a múltiplos idiomas
- **intl**: Internacionalização com ARB files
- **l10n**: Localização dinâmica (Português e Inglês)

### Widgets e Componentes
- **Widgets Reutilizáveis**: DoctorCard, ClinicCard, SpecialtyChip
- **Bottom Sheets**: Modais deslizantes com `DraggableScrollableSheet`
- **Formulários**: Validação e controle de inputs
- **ListView.builder**: Listas otimizadas com scroll
- **AlertDialog**: Diálogos de confirmação

## 📂 Estrutura de Assets

O projeto inclui screenshots da aplicação em light e dark mode, organizados por tela:

```
assets/
└── screenshots/
    ├── login/                        # Tela de login (light e dark)
    ├── busca/                        # Busca de clínicas (light e dark)
    ├── modal_confirmar_clinica/      # Modal de clínica (light e dark)
    ├── clinica/                      # Lista de médicos (light e dark)
    ├── medico/                       # Perfil do médico (light e dark)
    ├── modal_agendar_consulta/       # Modal agendar (4 imagens: 2 partes x 2 temas)
    └── confirmacao_agendamento/      # Confirmação (light e dark)
```

Cada pasta contém 2 imagens (light e dark mode), exceto `modal_agendar_consulta` que contém 4 imagens devido às duas partes do modal.

## 📝 Dados Fictícios

O app utiliza dados fictícios para fins de demonstração:

- **3 Clínicas**: Com endereços e distâncias simuladas
- **80 Médicos**: 10 médicos para cada uma das 8 especialidades
- **Avaliações**: Reviews fictícios com notas de 1 a 5 estrelas
- **Horários**: Disponibilidade de 8h às 12h
- **Dias**: Semana completa com alguns dias indisponíveis

## 🎯 Próximos Passos

### Arquitetura ✅
- [x] ~~Arquitetura SOLID~~ ✅
- [x] ~~Clean Architecture com camadas~~ ✅
- [x] ~~Dependency Injection~~ ✅
- [x] ~~Repository Pattern~~ ✅
- [x] ~~Use Cases~~ ✅

### Features Implementadas ✅
- [x] ~~Internacionalização (Português e Inglês)~~ ✅
- [x] ~~Sistema de logout~~ ✅
- [x] ~~Status bar adaptativa~~ ✅
- [x] ~~Widgets reutilizáveis~~ ✅
- [x] ~~Providers para estado~~ ✅

### Próximas Features 🚧
- [ ] Refatorar todas as Screens para usar nova arquitetura
- [ ] Testes unitários (Use Cases, Repositories)
- [ ] Testes de Widget
- [ ] Integração com API real
- [ ] Autenticação com Firebase
- [ ] Cache local (Hive/SQLite)
- [ ] Integração com Google Maps real
- [ ] Sistema de notificações
- [ ] Histórico de consultas
- [ ] Perfil do usuário
- [ ] Sistema de favoritos persistente
- [ ] Chat com médicos
- [ ] Pagamento online
- [ ] Prescrições digitais

---

## 📚 Documentação Adicional

- **[Arquitetura SOLID](docs/ARCHITECTURE.md)** - Documentação completa da arquitetura
- **[Sistema de Temas](lib/theme/README.md)** - Documentação do sistema de cores e temas
- **[Internacionalização](lib/l10n/README.md)** - Documentação do sistema de i18n

---

## 📄 Licença

Este projeto é um estudo de caso para fins educacionais.

---

**PatientCare** - Cuidando da sua saúde com excelência e carinho 🏥✨
