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
- **Tela de Cadastro**: Registro de novos usuários com nome, idade, email e senha
- **Recuperação de Senha**: Tela dedicada para resetar senha com validação de email
- **Edição de Perfil**: Permite atualizar nome, idade, email e senha do usuário
- **Cache Local**: Persistência de dados usando Hive (NoSQL)
- **Hash de Senhas**: Criptografia SHA256 para segurança
- **Gerenciamento de Sessão**: Controle de usuário logado
- **Validação de Email**: Verificação de duplicidade e formato
- **Alternância de Tema**: Botão para alternar entre light e dark mode
- **Seletor de Idioma**: Menu para escolher entre Português 🇧🇷 e English 🇺🇸
- **Logout**: Botão de logout com confirmação em todas as telas principais

### 📊 Perfil do Usuário
- **Header Personalizado**: Foto, nome e idade do usuário com gradiente azul
- **Botão Editar Perfil**: Acesso rápido para editar informações pessoais
- **Dashboard de Estatísticas**: Lista horizontal com scroll e 4 cards informativos:
  - Total de consultas realizadas
  - Consultas concluídas
  - Número de médicos únicos
  - Próximas consultas
- **Ações Rápidas** (Cards clicáveis):
  - 📅 **Minhas Consultas**: Acesso à tela dedicada de consultas (mostra quantidade agendada)
  - ⭐ **Meus Favoritos**: Médicos e clínicas favoritos
  - 📋 **Histórico Médico**: Consultas, exames e medicações
  - 🔔 **Lembretes**: Lembretes de consultas
- **Layout Limpo**: Perfil scrollável sem seções expandidas
- **Navegação Otimizada**: Bottom nav bar posicionada corretamente

### 📅 Minhas Consultas (Tela Dedicada)
- **Tela Completa**: Acesso via botão no perfil
- **Tabs com Contadores**: 
  - Tab "Abertas": Consultas agendadas (com contador)
  - Tab "Concluídas": Histórico completo (com contador)
- **Cards Informativos**: 
  - Médico, clínica, data, horário
  - Status colorido (Agendada/Concluída/Cancelada)
  - Tipo de consulta (Online/Presencial)
- **Ações**:
  - Cancelar consultas abertas com confirmação
  - Ver detalhes completos ao tocar no card
  - Pull-to-refresh para atualizar
  - Botão de atualizar no AppBar
- **Modal de Detalhes**: Todas as informações do agendamento
- **Status Dinâmico**: Atualização automática baseada na data
- **Empty States**: Mensagens personalizadas quando não há consultas

### 🧭 Navegação
- **Bottom Navigation Bar Flutuante**: 
  - Design verdadeiramente flutuante sobre o conteúdo
  - Bordas arredondadas e sombra elegante
  - Ícones com feedback visual ao selecionar
  - 2 botões: Busca de Clínicas e Perfil
  - Presente nas telas principais
  - Sem espaço branco embaixo (SafeArea otimizado)
  - Layout responsivo sem overflow

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
- **Botão de Favoritar**: Adicione médicos aos favoritos com um toque

### ⭐ Sistema de Favoritos
- **Armazenamento Local**: Favoritos persistem usando SharedPreferences
- **Botão de Favoritar**: Ícone de coração nas telas de médicos
- **Tela de Favoritos**: Acesse "Meus Favoritos" na tela de perfil
- **Lista Organizada**: Visualize todos os médicos e clínicas favoritos
- **Navegação Rápida**: Toque no favorito para ir direto ao perfil
- **Remover Favoritos**: Botão de coração vermelho para desfavoritar
- **Feedback Visual**: Animação e SnackBar ao adicionar/remover
- **Estado Sincronizado**: Provider gerencia estado globalmente

### 📋 Histórico Médico do Paciente
- **Armazenamento Local**: Dados persistem usando Hive (TypeId: 2)
- **Categorias Organizadas**: Consultas, Exames, Medicações, Cirurgias, Alergias, Vacinas
- **Busca por Título**: Campo de pesquisa dinâmico
- **Filtros**: Por categoria e ordenação (mais recente/mais antigo)
- **Adicionar Registros**: Formulário completo com:
  - Título e descrição
  - Data do registro
  - Categoria
  - Médico responsável (opcional)
  - Local (opcional)
  - Anexos (opcional)
- **Cards Informativos**: Data, categoria, médico e local
- **Editar/Excluir**: Toque no registro para editar ou excluir
- **Empty States**: Mensagens personalizadas por filtro

### 🔔 Lembretes de Consultas
- **Armazenamento Local**: Lembretes persistem usando Hive (TypeId: 3)
- **Filtros Inteligentes**: Todos, Hoje, Próximos, Vencidos (com contadores)
- **Painel de Estatísticas**: Resumo visual dos lembretes
- **Cards com Status**: 
  - 🔵 Hoje
  - 🟢 Próximos (mostra dias restantes)
  - 🟠 Vencidos
- **Adicionar/Editar Lembretes**:
  - Título e descrição
  - Data e hora da consulta
  - Data e hora do lembrete
  - Sugestões rápidas (1 dia, 2 dias, 1 semana antes)
  - Médico e local (opcional)
  - Observações (opcional)
- **Propriedades Úteis**: `isOverdue`, `isToday`, `isTomorrow`, `daysUntilAppointment`
- **Excluir com Confirmação**: Diálogo antes de remover
- **Navegação**: Toque para editar os detalhes

### 📊 Estatísticas de Saúde
- **Armazenamento Local**: Métricas persistem usando Hive (TypeId: 10, 11)
- **Tipos de Métricas Suportadas**:
  - Peso, Altura, IMC
  - Pressão Arterial, Frequência Cardíaca
  - Temperatura, Glicemia, Colesterol
  - Passos, Horas de Sono, Ingestão de Água
  - Humor, Nível de Dor, Energia, Estresse
- **Interface com 3 Abas**:
  - **Visão Geral**: Resumo das métricas mais recentes
  - **Gráficos**: Visualizações interativas (linha e barras)
  - **Análises**: Análises inteligentes com recomendações
- **Funcionalidades Avançadas**:
  - Gráficos interativos com fl_chart
  - Análises automáticas com status (excelente/bom/atenção/crítico)
  - Cálculo de tendências (subindo/descendo/estável)
  - Filtros por período personalizáveis
  - CRUD completo para métricas
- **Widgets Especializados**:
  - `HealthLineChartWidget`: Gráficos de linha com área preenchida
  - `HealthBarChartWidget`: Gráficos de barras interativos
  - `HealthStatisticsCard`: Cards com estatísticas detalhadas
  - `HealthAnalysisCard`: Cards com análises e recomendações
  - `HealthMetricCard`: Cards para métricas individuais
- **Arquitetura Clean**:
  - Repository Pattern com `HealthStatisticsRepository`
  - 10 Use Cases específicos para cada operação
  - Provider para gerenciamento de estado
  - Models tipados com Hive TypeAdapter
- **Integração Completa**:
  - Roteamento configurado (`/health-statistics`)
  - Dependency Injection atualizada
  - Tema Dark/Light compatível
  - Dependências: fl_chart, uuid

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
- **Persistência Automática**: Agendamento salvo no Hive ao confirmar
- **Sincronização com Perfil**: Dados aparecem automaticamente na tela de perfil

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

### 🌐 Integração com API Real
- **JSONPlaceholder API**: Integração com API externa de teste
- **API Gateway**: Cliente HTTP centralizado com tratamento de erros
- **Tela de Usuários**: Lista usuários reais da API com busca e pull-to-refresh
- **Models Tipados**: UserModel, AddressModel, CompanyModel com serialização JSON
- **Loading States**: Indicadores de carregamento, erro e estado vazio
- **Cards Expansíveis**: Detalhes completos de cada usuário (email, telefone, empresa, endereço)
- **Arquitetura SOLID**: Remote Datasource, Repository, Use Cases e Provider

### 💾 Cache Local e Autenticação
- **Hive Database**: NoSQL local para persistência de dados
- **AuthService**: Serviço completo de autenticação
  - Cadastro de usuários com validação
  - Login com verificação de credenciais
  - Hash de senhas (SHA256)
  - Gerenciamento de sessão
  - Verificação de email duplicado
- **AppointmentService**: Gerenciamento de agendamentos
  - Salvar novos agendamentos com ano dinâmico (2025)
  - Buscar agendamentos abertos/fechados
  - Marcar como concluído automaticamente (1 hora após o horário)
  - **Cancelar consultas** com timestamp
  - **Atualização automática de status**: Consultas passadas vão para "Fechados"
  - **Reabertura inteligente**: Consultas futuras marcadas incorretamente são reabertas
  - Calcular estatísticas em tempo real
  - Filtros inteligentes: Abertos (não concluídos e não cancelados), Fechados (concluídos ou cancelados)
  - Deletar agendamentos
- **Models Persistidos com Hive TypeAdapter**:
  - `LocalUserModel` (TypeId: 0): Usuários cadastrados com nome e idade
  - `AppointmentSavedModel` (TypeId: 1): Agendamentos com status de cancelamento e timestamps
  - `MedicalRecordModel` (TypeId: 2): Registros de histórico médico completo
  - `ReminderModel` (TypeId: 3): Lembretes de consultas com datas e status
  - `HealthMetricModel` (TypeId: 10): Métricas individuais de saúde
  - `HealthStatisticsModel` (TypeId: 11): Estatísticas agregadas de saúde
- **Dependency Injection**: Services registrados no GetIt
- **Fluxo Completo**: Login → Busca → Agendamento → Persistência → Perfil

## 🏗️ Arquitetura SOLID

O projeto segue os princípios **SOLID** e **Clean Architecture** com separação clara em camadas:

```
lib/
├── main.dart                           # Ponto de entrada (inicializa Hive + DI)
├── core/                               # Funcionalidades compartilhadas
│   ├── constants/                      # Constantes da aplicação
│   ├── network/                        # API Gateway e cliente HTTP
│   ├── services/                       # Serviços utilitários
│   │   ├── auth_service.dart           # 🆕 Autenticação local
│   │   ├── appointment_service.dart    # 🆕 Gerenciamento de agendamentos
│   │   ├── favorites_service.dart      # ⭐ Gerenciamento de favoritos
│   │   ├── medical_history_service.dart # 📋 Gerenciamento de histórico médico
│   │   ├── reminder_service.dart       # 🔔 Gerenciamento de lembretes
│   │   ├── health_statistics_service.dart # 📊 Gerenciamento de estatísticas de saúde
│   │   └── specialty_translation_service.dart
│   ├── utils/                          # Helpers e formatadores
│   └── di/                             # Dependency Injection (GetIt)
├── data/                               # Camada de Dados
│   ├── models/                         # Models (DTOs)
│   │   ├── local_user_model.dart       # 🆕 Model para usuário local (Hive)
│   │   ├── appointment_saved_model.dart # 🆕 Model para agendamentos (Hive)
│   │   ├── favorite_model.dart         # ⭐ Model para favoritos (JSON)
│   │   ├── medical_record_model.dart   # 📋 Model para histórico médico (Hive)
│   │   ├── reminder_model.dart         # 🔔 Model para lembretes (Hive)
│   │   ├── health_statistics_model.dart # 📊 Model para estatísticas de saúde (Hive)
│   │   ├── user_model.dart             # Model da API
│   │   ├── doctor_model.dart
│   │   └── ...
│   ├── datasources/                    # Fontes de dados (local/API)
│   │   ├── local_doctors_datasource.dart
│   │   ├── remote_users_datasource.dart
│   │   └── ...
│   └── repositories/                   # Implementações de repositórios
│       ├── favorites_repository_impl.dart      # ⭐ Impl de favoritos
│       ├── medical_history_repository_impl.dart # 📋 Impl de histórico
│       ├── reminder_repository_impl.dart       # 🔔 Impl de lembretes
│       ├── health_statistics_repository_impl.dart # 📊 Impl de estatísticas
│       └── ...
├── domain/                             # Camada de Domínio (Regras de Negócio)
│   ├── repositories/                   # Contratos (interfaces abstratas)
│   │   ├── favorites_repository.dart         # ⭐ Interface de favoritos
│   │   ├── medical_history_repository.dart   # 📋 Interface de histórico
│   │   ├── reminder_repository.dart          # 🔔 Interface de lembretes
│   │   ├── health_statistics_repository.dart # 📊 Interface de estatísticas
│   │   └── ...
│   └── usecases/                       # Casos de uso
├── presentation/                       # Camada de Apresentação (UI)
│   ├── providers/                      # State management (ChangeNotifier)
│   │   ├── favorites_provider.dart          # ⭐ Provider de favoritos
│   │   ├── medical_history_provider.dart    # 📋 Provider de histórico
│   │   ├── reminder_provider.dart           # 🔔 Provider de lembretes
│   │   ├── health_statistics_provider.dart  # 📊 Provider de estatísticas
│   │   └── ...
│   └── widgets/                        # Widgets reutilizáveis
│       ├── floating_nav_bar.dart       # 🆕 Bottom nav bar flutuante
│       ├── favorite_button.dart        # ⭐ Botão de favoritar
│       ├── health_chart_widget.dart   # 📊 Widgets de gráficos
│       ├── health_statistics_widget.dart # 📊 Widgets de estatísticas
│       └── ...
├── screens/                            # Telas principais
│   ├── login_screen.dart
│   ├── register_screen.dart            # 🆕 Tela de cadastro com nome e idade
│   ├── forgot_password_screen.dart     # 🆕 Tela de recuperação de senha
│   ├── edit_profile_screen.dart        # 🆕 Tela de edição de perfil
│   ├── profile_screen.dart             # 🆕 Tela de perfil otimizada
│   ├── my_appointments_screen.dart     # 📅 Tela dedicada de consultas
│   ├── favorites_screen.dart           # ⭐ Tela de favoritos
│   ├── medical_history_screen.dart     # 📋 Tela de histórico médico
│   ├── add_medical_record_screen.dart  # 📋 Formulário de registro médico
│   ├── reminders_screen.dart           # 🔔 Tela de lembretes
│   ├── add_reminder_screen.dart        # 🔔 Formulário de lembrete
│   ├── health_statistics_screen.dart    # 📊 Tela de estatísticas de saúde
│   └── ...
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
  http: ^1.2.0                # Cliente HTTP para chamadas de API
  hive: ^2.2.3                # Cache local NoSQL
  hive_flutter: ^1.1.0        # Hive para Flutter
  crypto: ^3.0.3              # Hash de senhas (SHA256)
  shared_preferences: ^2.2.2  # ⭐ Armazenamento local (favoritos)
  json_annotation: ^4.8.1     # ⭐ Anotações JSON
  fl_chart: ^0.68.0           # 📊 Gráficos interativos
  uuid: ^4.4.0                # 📊 Geração de IDs únicos

dev_dependencies:
  hive_generator: ^2.0.1      # Gerador de adapters Hive
  build_runner: ^2.4.9        # Code generation
  json_serializable: ^6.7.1   # ⭐ Serialização JSON
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

### Persistência e Cache
- **Hive**: Banco de dados NoSQL local
- **Hive Flutter**: Integração otimizada para Flutter
- **TypeAdapter**: Serialização automática de models
- **Crypto**: Hash SHA256 para senhas

### Internacionalização
- **flutter_localizations**: Suporte oficial a múltiplos idiomas
- **intl**: Internacionalização com ARB files
- **l10n**: Localização dinâmica (Português e Inglês)

### Widgets e Componentes
- **Widgets Reutilizáveis**: DoctorCard, ClinicCard, SpecialtyChip, FloatingNavBar
- **Bottom Navigation Bar**: Navegação flutuante com animações
- **Bottom Sheets**: Modais deslizantes com `DraggableScrollableSheet`
- **TabBar Personalizada**: Abas com indicador animado e sombra
- **Formulários**: Validação e controle de inputs
- **ListView.builder**: Listas otimizadas com scroll
- **AlertDialog**: Diálogos de confirmação
- **Empty States**: Estados vazios personalizados

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

## 📝 Dados do Aplicativo

### Dados Locais (Mockados)
- **3 Clínicas**: Com endereços e distâncias simuladas
- **40 Médicos**: 5 médicos para cada uma das 8 especialidades (nomes da API)
- **Avaliações**: Reviews fictícios com notas de 1 a 5 estrelas
- **Horários**: Disponibilidade de 8h às 12h
- **Dias**: Semana completa com alguns dias indisponíveis

### Dados Persistidos (Hive)
- **Usuários Locais** (Box: `users`):
  - Cadastro com nome, idade, email e senha (hash SHA256)
  - Edição de perfil (atualizar dados e senha)
  - Recuperação de senha
  - Sessão de usuário logado
  - Validação: Email único, senha mínima de 6 caracteres, idade entre 1-150
- **Agendamentos** (Box: `appointments`):
  - Dados completos do agendamento com ano dinâmico
  - Status (aberto/fechado/cancelado)
  - Data de criação, conclusão e cancelamento
  - **Gestão automática de status**: Consultas movem para "Fechados" 1h após o horário
  - **Reabertura automática**: Corrige consultas futuras marcadas incorretamente
  - Estatísticas em tempo real
- **Preferências** (Box: `preferences`):
  - Email do usuário atual
  - Configurações do app

### Dados da API Real
- **10 Usuários**: Da API [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
- **Endpoints Ativos**: GET `/users`, `/users/{id}`, POST/PUT/DELETE (simulados)
- **Dados Completos**: Nome, email, telefone, endereço, empresa, website
- **Integração**: Nomes dos médicos vêm da API real
- **Tela Funcional**: `/users` - Acesse navegando para esta rota

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

### Testes ✅
- [x] ~~Testes unitários (Use Cases, Repositories, Providers)~~ ✅ **32+ testes passando**
- [x] ~~Testes de Widget~~ ✅
- [x] ~~Refatorar todas as Screens para usar nova arquitetura~~ ✅
- [x] ~~Integração com API real (JSONPlaceholder)~~ ✅
- [x] ~~Cache local (Hive/SQLite)~~ ✅ **Hive implementado**
- [ ] Testes de Integração
- [ ] Aumentar cobertura de testes (> 80%)

### Integração com API ✅
- [x] ~~Integração com API JSONPlaceholder~~ ✅
- [x] ~~API Gateway HTTP centralizado~~ ✅
- [x] ~~Tela de usuários com busca~~ ✅
- [x] ~~Models tipados (User, Address, Company)~~ ✅
- [x] ~~Remote Datasource com tratamento de erros~~ ✅

### Features Implementadas Recentemente ✅
- [x] ~~Recuperação de senha (Forgot Password)~~ ✅
- [x] ~~Edição de perfil completa (nome, idade, email, senha)~~ ✅
- [x] ~~Cadastro com dados pessoais (nome e idade)~~ ✅
- [x] ~~Cancelamento de consultas com confirmação~~ ✅
- [x] ~~Atualização automática de status de consultas~~ ✅
- [x] ~~Bottom Nav Bar flutuante otimizada~~ ✅
- [x] ~~Dashboard de estatísticas com scroll horizontal~~ ✅
- [x] ~~Badges de status diferenciados (Concluído/Cancelado)~~ ✅
- [x] ~~Sistema de favoritos persistente~~ ✅
- [x] ~~Histórico médico do paciente~~ ✅
- [x] ~~Lembretes de consultas~~ ✅
- [x] ~~Tela dedicada para consultas~~ ✅
- [x] ~~Perfil otimizado com navegação por cards~~ ✅
- [x] ~~Estatísticas de saúde com gráficos e análises~~ ✅

### Próximas Features 🚧
- [ ] Autenticação com Firebase (OAuth, Google Sign-In)
- [ ] Integração com Google Maps real
- [ ] Sistema de notificações push
- [ ] Sincronização com backend
- [ ] Chat com médicos em tempo real
- [ ] Pagamento online integrado
- [ ] Prescrições digitais
- [ ] Upload de anexos no histórico médico

---

## 📚 Documentação Adicional

- **[Arquitetura SOLID](docs/ARCHITECTURE.md)** - Documentação completa da arquitetura
- **[Integração com API](docs/API_INTEGRATION.md)** - Documentação da integração com JSONPlaceholder
- **[Testes](docs/TESTING.md)** - Documentação completa de testes (32+ testes ✅)
- **[Sistema de Temas](lib/theme/README.md)** - Documentação do sistema de cores e temas
- **[Internacionalização](lib/l10n/README.md)** - Documentação do sistema de i18n

---

## 📄 Licença

Este projeto é um estudo de caso para fins educacionais.

---

**PatientCare** - Cuidando da sua saúde com excelência e carinho 🏥✨
