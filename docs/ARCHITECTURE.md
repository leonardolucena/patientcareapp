# 🏗️ Arquitetura SOLID do PatientCare App

Este documento descreve a arquitetura do projeto, que segue os princípios SOLID e Clean Architecture.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Princípios SOLID](#princípios-solid)
- [Estrutura de Camadas](#estrutura-de-camadas)
- [Fluxo de Dados](#fluxo-de-dados)
- [Dependency Injection](#dependency-injection)
- [Como Usar](#como-usar)

---

## 🎯 Visão Geral

O projeto utiliza **Clean Architecture** com separação clara de responsabilidades em camadas:

```
lib/
├── core/                    # Funcionalidades compartilhadas
│   ├── constants/           # Constantes da aplicação
│   ├── services/            # Serviços utilitários
│   ├── utils/               # Utilitários e helpers
│   └── di/                  # Dependency Injection
├── data/                    # Camada de dados
│   ├── models/              # Models (DTOs)
│   ├── datasources/         # Fontes de dados
│   └── repositories/        # Implementações de repositórios
├── domain/                  # Camada de domínio (regras de negócio)
│   ├── repositories/        # Contratos (interfaces)
│   └── usecases/            # Casos de uso
├── presentation/            # Camada de apresentação (UI)
│   ├── providers/           # State management
│   ├── screens/             # Telas
│   └── widgets/             # Widgets reutilizáveis
└── l10n/                    # Internacionalização
```

---

## 🔷 Princípios SOLID

### 1. **S - Single Responsibility Principle (SRP)**

✅ **Cada classe tem uma única responsabilidade**

- **Use Cases**: Cada use case realiza apenas uma operação específica
  - `GetAllDoctorsUseCase` - apenas busca médicos
  - `SearchDoctorsUseCase` - apenas pesquisa por nome
  - `CreateAppointmentUseCase` - apenas cria agendamentos

- **Models**: Representam apenas estruturas de dados
- **Widgets**: Cada widget tem uma responsabilidade visual específica

```dart
// ✅ BOM: Uma responsabilidade
class GetAllDoctorsUseCase {
  Future<List<DoctorModel>> call() async {
    return await _repository.getAllDoctors();
  }
}

// ❌ RUIM: Múltiplas responsabilidades
class DoctorService {
  Future<List<DoctorModel>> getAllDoctors() { }
  Future<void> saveDoctor() { }
  String formatDoctorName() { }
  Widget buildDoctorCard() { }
}
```

### 2. **O - Open/Closed Principle (OCP)**

✅ **Aberto para extensão, fechado para modificação**

- **Repositories**: Usam interfaces, permitindo diferentes implementações
- **Datasources**: Podem ser trocados (local → API) sem modificar código

```dart
// Interface (contrato)
abstract class DoctorRepository {
  Future<List<DoctorModel>> getAllDoctors();
}

// Implementação atual (local)
class DoctorRepositoryImpl implements DoctorRepository {
  final LocalDoctorsDatasource _datasource;
  // ...
}

// Nova implementação (API) - sem modificar código existente
class DoctorRepositoryApiImpl implements DoctorRepository {
  final ApiDoctorsDatasource _datasource;
  // ...
}
```

### 3. **L - Liskov Substitution Principle (LSP)**

✅ **Objetos podem ser substituídos por suas subclasses**

- Qualquer implementação de `DoctorRepository` pode ser usada
- Use Cases dependem apenas da interface, não da implementação

```dart
// Use Case depende da abstração
class GetAllDoctorsUseCase {
  final DoctorRepository _repository; // Interface
  
  // Funciona com QUALQUER implementação de DoctorRepository
  Future<List<DoctorModel>> call() async {
    return await _repository.getAllDoctors();
  }
}
```

### 4. **I - Interface Segregation Principle (ISP)**

✅ **Interfaces específicas são melhores que interfaces gerais**

- Cada repository tem apenas os métodos necessários
- Não há métodos "gordos" que fazem muita coisa

```dart
// ✅ BOM: Interface específica
abstract class DoctorRepository {
  Future<List<DoctorModel>> getAllDoctors();
  Future<DoctorModel?> getDoctorById(String id);
}

// ✅ BOM: Interface separada para reviews
abstract class ReviewRepository {
  Future<List<ReviewModel>> getReviewsByDoctorId(String doctorId);
  Future<void> addReview(ReviewModel review);
}

// ❌ RUIM: Interface "gorda"
abstract class MegaRepository {
  Future<List<DoctorModel>> getAllDoctors();
  Future<List<ClinicModel>> getAllClinics();
  Future<void> createAppointment();
  Future<void> deleteEverything();
}
```

### 5. **D - Dependency Inversion Principle (DIP)**

✅ **Dependa de abstrações, não de implementações concretas**

- Use Cases dependem de **interfaces** de repositórios
- Repositórios são injetados via **Dependency Injection**
- Camadas superiores não conhecem detalhes de implementação

```dart
// ✅ BOM: Depende de abstração (interface)
class GetAllDoctorsUseCase {
  final DoctorRepository _repository; // <- Interface
  
  GetAllDoctorsUseCase(this._repository);
}

// ❌ RUIM: Depende de implementação concreta
class GetAllDoctorsUseCase {
  final DoctorRepositoryImpl _repository; // <- Implementação
  
  GetAllDoctorsUseCase() {
    _repository = DoctorRepositoryImpl(); // <- Hard-coded
  }
}
```

---

## 🏛️ Estrutura de Camadas

### 1. **Core Layer** (Compartilhado)

```
core/
├── constants/              # Constantes globais
│   └── app_constants.dart
├── services/               # Serviços compartilhados
│   └── specialty_translation_service.dart
├── utils/                  # Utilitários
│   ├── date_formatter.dart
│   └── id_generator.dart
└── di/                     # Dependency Injection
    └── injection_container.dart
```

**Responsabilidades:**
- Constantes da aplicação
- Serviços utilitários (tradução, formatação)
- Helpers e extensões
- Configuração de DI

### 2. **Data Layer** (Acesso a Dados)

```
data/
├── models/                 # DTOs (Data Transfer Objects)
│   ├── doctor_model.dart
│   ├── clinic_model.dart
│   ├── specialty_model.dart
│   ├── review_model.dart
│   └── appointment_model.dart
├── datasources/            # Fontes de dados
│   ├── local_doctors_datasource.dart
│   ├── local_clinics_datasource.dart
│   ├── local_specialties_datasource.dart
│   └── local_reviews_datasource.dart
└── repositories/           # Implementações
    ├── doctor_repository_impl.dart
    ├── clinic_repository_impl.dart
    ├── specialty_repository_impl.dart
    ├── review_repository_impl.dart
    └── appointment_repository_impl.dart
```

**Responsabilidades:**
- Definir estruturas de dados (Models)
- Acessar fontes de dados (local, API, cache)
- Implementar repositórios

**Models:**
```dart
class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  // ...
  
  // Serialização
  factory DoctorModel.fromJson(Map<String, dynamic> json) { }
  Map<String, dynamic> toJson() { }
  
  // Métodos utilitários
  DoctorModel copyWith({ ... }) { }
}
```

### 3. **Domain Layer** (Regras de Negócio)

```
domain/
├── repositories/           # Contratos (abstrações)
│   ├── doctor_repository.dart
│   ├── clinic_repository.dart
│   ├── specialty_repository.dart
│   ├── review_repository.dart
│   └── appointment_repository.dart
└── usecases/               # Casos de uso
    ├── get_all_doctors_usecase.dart
    ├── get_doctors_by_specialty_usecase.dart
    ├── search_doctors_usecase.dart
    ├── get_all_clinics_usecase.dart
    ├── search_clinics_usecase.dart
    ├── get_all_specialties_usecase.dart
    ├── get_doctor_reviews_usecase.dart
    └── create_appointment_usecase.dart
```

**Responsabilidades:**
- Definir contratos (interfaces)
- Implementar lógica de negócio
- Cada use case = uma operação específica

**Repository (Interface):**
```dart
abstract class DoctorRepository {
  Future<List<DoctorModel>> getAllDoctors();
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty);
  Future<DoctorModel?> getDoctorById(String id);
}
```

**Use Case:**
```dart
class GetAllDoctorsUseCase {
  final DoctorRepository _repository;

  GetAllDoctorsUseCase(this._repository);

  Future<List<DoctorModel>> call() async {
    return await _repository.getAllDoctors();
  }
}
```

### 4. **Presentation Layer** (UI)

```
presentation/
├── providers/              # State management
│   ├── doctors_provider.dart
│   └── clinics_provider.dart
├── screens/                # Telas da aplicação
│   ├── login_screen.dart
│   ├── search_clinics_screen.dart
│   ├── doctors_list_screen.dart
│   ├── doctor_profile_screen.dart
│   └── appointment_confirmation_screen.dart
└── widgets/                # Widgets reutilizáveis
    ├── doctor_card_widget.dart
    ├── clinic_card_widget.dart
    └── specialty_chip_widget.dart
```

**Responsabilidades:**
- Gerenciar estado (Providers)
- Renderizar UI (Widgets)
- Interagir com usuário

**Provider:**
```dart
class DoctorsProvider extends ChangeNotifier {
  final GetAllDoctorsUseCase _getAllDoctorsUseCase;
  
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;
  
  Future<void> loadAllDoctors() async {
    _isLoading = true;
    notifyListeners();
    
    _doctors = await _getAllDoctorsUseCase();
    _isLoading = false;
    notifyListeners();
  }
}
```

---

## 🔄 Fluxo de Dados

### Exemplo: Carregar Lista de Médicos

```
┌─────────────┐
│   Screen    │  1. Usuário abre tela
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Provider   │  2. Provider chama Use Case
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Use Case   │  3. Use Case executa lógica de negócio
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Repository  │  4. Repository busca dados
│ (Interface) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Repository  │  5. Implementação acessa Datasource
│    Impl     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Datasource  │  6. Datasource retorna dados
│             │
└──────┬──────┘
       │
       ▼
       Dados retornam pela mesma cadeia
       │
       ▼
┌─────────────┐
│   Screen    │  7. UI atualiza com dados
└─────────────┘
```

### Código Completo do Fluxo:

```dart
// 1. SCREEN
class DoctorsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorsProvider()..loadAllDoctors(),
      child: Consumer<DoctorsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: provider.doctors.length,
            itemBuilder: (_, index) => DoctorCardWidget(
              doctor: provider.doctors[index],
            ),
          );
        },
      ),
    );
  }
}

// 2. PROVIDER
class DoctorsProvider extends ChangeNotifier {
  final GetAllDoctorsUseCase _useCase = getIt<GetAllDoctorsUseCase>();
  
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;
  
  Future<void> loadAllDoctors() async {
    _isLoading = true;
    notifyListeners();
    
    _doctors = await _useCase(); // Chama Use Case
    _isLoading = false;
    notifyListeners();
  }
}

// 3. USE CASE
class GetAllDoctorsUseCase {
  final DoctorRepository _repository;
  
  GetAllDoctorsUseCase(this._repository);
  
  Future<List<DoctorModel>> call() async {
    return await _repository.getAllDoctors();
  }
}

// 4. REPOSITORY (Interface)
abstract class DoctorRepository {
  Future<List<DoctorModel>> getAllDoctors();
}

// 5. REPOSITORY (Implementação)
class DoctorRepositoryImpl implements DoctorRepository {
  final LocalDoctorsDatasource _datasource;
  
  DoctorRepositoryImpl(this._datasource);
  
  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    await Future.delayed(Duration(milliseconds: 300)); // Simula rede
    return _datasource.getAllDoctors();
  }
}

// 6. DATASOURCE
class LocalDoctorsDatasource {
  List<DoctorModel> getAllDoctors() {
    return [
      DoctorModel(id: '1', name: 'Dr. Silva', ...),
      DoctorModel(id: '2', name: 'Dra. Santos', ...),
    ];
  }
}
```

---

## 💉 Dependency Injection

Usamos **GetIt** como Service Locator para Dependency Injection.

### Configuração (injection_container.dart):

```dart
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Datasources
  getIt.registerLazySingleton(() => LocalDoctorsDatasource());
  
  // Repositories
  getIt.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(getIt()),
  );
  
  // Use Cases
  getIt.registerFactory(() => GetAllDoctorsUseCase(getIt()));
}
```

### Inicialização (main.dart):

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(MyApp());
}
```

### Uso:

```dart
// No Provider ou onde precisar
final useCase = getIt<GetAllDoctorsUseCase>();
final doctors = await useCase();
```

---

## 🚀 Como Usar

### 1. Criar um Novo Model:

```dart
// lib/data/models/patient_model.dart
class PatientModel {
  final String id;
  final String name;
  
  const PatientModel({required this.id, required this.name});
  
  factory PatientModel.fromJson(Map<String, dynamic> json) { }
  Map<String, dynamic> toJson() { }
}
```

### 2. Criar Repository (Interface):

```dart
// lib/domain/repositories/patient_repository.dart
abstract class PatientRepository {
  Future<List<PatientModel>> getAllPatients();
}
```

### 3. Criar Repository (Implementação):

```dart
// lib/data/repositories/patient_repository_impl.dart
class PatientRepositoryImpl implements PatientRepository {
  final LocalPatientsDatasource _datasource;
  
  PatientRepositoryImpl(this._datasource);
  
  @override
  Future<List<PatientModel>> getAllPatients() async {
    return _datasource.getAllPatients();
  }
}
```

### 4. Criar Use Case:

```dart
// lib/domain/usecases/get_all_patients_usecase.dart
class GetAllPatientsUseCase {
  final PatientRepository _repository;
  
  GetAllPatientsUseCase(this._repository);
  
  Future<List<PatientModel>> call() async {
    return await _repository.getAllPatients();
  }
}
```

### 5. Registrar no DI:

```dart
// lib/core/di/injection_container.dart
void initializeDependencies() {
  // Datasource
  getIt.registerLazySingleton(() => LocalPatientsDatasource());
  
  // Repository
  getIt.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(getIt()),
  );
  
  // Use Case
  getIt.registerFactory(() => GetAllPatientsUseCase(getIt()));
}
```

### 6. Usar no Provider/Screen:

```dart
class PatientsProvider extends ChangeNotifier {
  final GetAllPatientsUseCase _useCase = getIt<GetAllPatientsUseCase>();
  
  Future<void> loadPatients() async {
    final patients = await _useCase();
    // ...
  }
}
```

---

## ✅ Benefícios da Arquitetura

1. **Testabilidade**: Cada camada pode ser testada isoladamente
2. **Manutenibilidade**: Mudanças em uma camada não afetam outras
3. **Escalabilidade**: Fácil adicionar novos recursos
4. **Flexibilidade**: Fácil trocar implementações (local → API)
5. **Clareza**: Responsabilidades bem definidas
6. **Reusabilidade**: Widgets e use cases reutilizáveis

---

## 📚 Referências

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Flutter Architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [GetIt Documentation](https://pub.dev/packages/get_it)

