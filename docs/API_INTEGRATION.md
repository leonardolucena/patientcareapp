# 🌐 Integração com API JSONPlaceholder

Documentação completa da integração com a API externa [JSONPlaceholder](https://jsonplaceholder.typicode.com/).

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [API Gateway](#api-gateway)
4. [Models](#models)
5. [Datasources](#datasources)
6. [Repositories](#repositories)
7. [Use Cases](#use-cases)
8. [Provider](#provider)
9. [UI](#ui)
10. [Como Usar](#como-usar)
11. [Testes](#testes)

---

## Visão Geral

Implementamos integração completa com a API JSONPlaceholder seguindo os princípios SOLID e Clean Architecture.

### Características

✅ **Gateway HTTP Centralizado** - Um único ponto para chamadas HTTP  
✅ **Tipagem Forte** - Models tipados para todos os objetos  
✅ **Tratamento de Erros** - Exceptions customizadas e handling robusto  
✅ **Dependency Injection** - GetIt para gerenciar dependências  
✅ **State Management** - Provider para gerenciar estado  
✅ **UI Responsiva** - Tela de exemplo completa com loading, error e empty states  

---

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│ 📱 Presentation Layer                                       │
│  ├── UsersListScreen (UI)                                  │
│  └── UsersProvider (State Management)                      │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 🎯 Domain Layer                                             │
│  ├── UserRepository (Interface)                            │
│  ├── GetAllUsersUseCase                                    │
│  └── SearchUsersUseCase                                    │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 📦 Data Layer                                               │
│  ├── UserRepositoryImpl                                    │
│  ├── RemoteUsersDatasource                                 │
│  └── Models (User, Address, Company, Geo)                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 🌐 Core Layer                                               │
│  ├── ApiGateway (HTTP Client)                              │
│  └── Dependency Injection (GetIt)                          │
└─────────────────────────────────────────────────────────────┘
```

---

## API Gateway

**Arquivo:** `lib/core/network/api_gateway.dart`

Gateway centralizado para todas as chamadas HTTP.

### Funcionalidades

- ✅ GET, POST, PUT, DELETE
- ✅ Headers padronizados
- ✅ Tratamento de status codes
- ✅ Exceptions customizadas
- ✅ URL base configurável

### Exemplo de Uso

```dart
final gateway = ApiGateway();

// GET request
final response = await gateway.get('/users');

// POST request
final response = await gateway.post(
  '/users',
  body: {'name': 'John Doe'},
);

// Tratamento de erros
try {
  await gateway.get('/users');
} on ApiException catch (e) {
  print('Erro: ${e.message}');
}
```

---

## Models

### UserModel

**Arquivo:** `lib/data/models/user_model.dart`

```dart
class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final AddressModel address;
  final String phone;
  final String website;
  final CompanyModel company;
  
  // Getter útil
  String get initials; // Retorna iniciais do nome
}
```

### AddressModel

**Arquivo:** `lib/data/models/address_model.dart`

```dart
class AddressModel {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoModel geo;
  
  // Getter útil
  String get fullAddress; // Retorna endereço formatado
}
```

### CompanyModel

**Arquivo:** `lib/data/models/company_model.dart`

```dart
class CompanyModel {
  final String name;
  final String catchPhrase;
  final String bs;
}
```

### GeoModel

**Arquivo:** `lib/data/models/geo_model.dart`

```dart
class GeoModel {
  final String lat;
  final String lng;
}
```

---

## Datasources

### RemoteUsersDatasource

**Arquivo:** `lib/data/datasources/remote_users_datasource.dart`

Responsável por fazer chamadas HTTP para a API.

```dart
class RemoteUsersDatasource {
  final ApiGateway _apiGateway;
  
  // Busca todos usuários
  Future<List<UserModel>> getAllUsers();
  
  // Busca usuário por ID
  Future<UserModel?> getUserById(int id);
  
  // Busca usuários por nome
  Future<List<UserModel>> searchUsersByName(String name);
  
  // CRUD operations (simuladas)
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}
```

---

## Repositories

### UserRepository (Interface)

**Arquivo:** `lib/domain/repositories/user_repository.dart`

```dart
abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(int id);
  Future<List<UserModel>> searchUsersByName(String name);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}
```

### UserRepositoryImpl

**Arquivo:** `lib/data/repositories/user_repository_impl.dart`

Implementação que delega para o datasource.

```dart
class UserRepositoryImpl implements UserRepository {
  final RemoteUsersDatasource _remoteDatasource;
  
  @override
  Future<List<UserModel>> getAllUsers() async {
    return await _remoteDatasource.getAllUsers();
  }
  // ... outros métodos
}
```

---

## Use Cases

### GetAllUsersUseCase

**Arquivo:** `lib/domain/usecases/get_all_users_usecase.dart`

```dart
class GetAllUsersUseCase {
  final UserRepository _repository;
  
  Future<List<UserModel>> call() async {
    return await _repository.getAllUsers();
  }
}
```

### SearchUsersUseCase

**Arquivo:** `lib/domain/usecases/search_users_usecase.dart`

```dart
class SearchUsersUseCase {
  final UserRepository _repository;
  
  Future<List<UserModel>> call(String query) async {
    if (query.isEmpty) {
      return await _repository.getAllUsers();
    }
    return await _repository.searchUsersByName(query);
  }
}
```

---

## Provider

### UsersProvider

**Arquivo:** `lib/presentation/providers/users_provider.dart`

Gerencia o estado da tela de usuários.

```dart
class UsersProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  
  // Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Métodos
  Future<void> loadAllUsers();
  Future<void> searchUsers(String query);
  void clearSearch();
  Future<void> refresh();
  UserModel? getUserById(int id);
}
```

### Uso

```dart
// No build method
Consumer<UsersProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: provider.users.length,
      itemBuilder: (context, index) {
        final user = provider.users[index];
        return UserCard(user: user);
      },
    );
  },
)
```

---

## UI

### UsersListScreen

**Arquivo:** `lib/screens/users_list_screen.dart`

Tela completa para exibir usuários da API.

#### Funcionalidades

✅ **Busca** - Campo de busca por nome/username  
✅ **Pull to Refresh** - Arrasta para baixo para recarregar  
✅ **Loading State** - CircularProgressIndicator durante loading  
✅ **Error State** - Mensagem de erro com botão "Tentar Novamente"  
✅ **Empty State** - Mensagem quando não há usuários  
✅ **Cards Expansíveis** - Toque para expandir e ver detalhes  
✅ **Avatar** - Iniciais do nome em círculo colorido  
✅ **Dark Mode** - Botão para alternar tema  
✅ **Status Bar** - Adapta ao tema atual  

#### Screenshots

```
+------------------+
| Usuários API   🌙|
+------------------+
| 🔍 Buscar...     |
+------------------+
|  LG  Leanne    > |
|      Sincere@... |
+------------------+
|  EH  Ervin     > |
|      Shanna@...  |
+------------------+
```

---

## Como Usar

### 1. Navegar para a tela

```dart
// No seu código
context.go('/users');

// Ou
context.goNamed('users');
```

### 2. Usar o Provider diretamente

```dart
final provider = Provider.of<UsersProvider>(context, listen: false);

// Carregar usuários
await provider.loadAllUsers();

// Buscar
await provider.searchUsers('Leanne');

// Limpar busca
provider.clearSearch();

// Refresh
await provider.refresh();

// Buscar por ID
final user = provider.getUserById(1);
```

### 3. Usar os Use Cases diretamente

```dart
// Obter da DI
final getAllUsersUseCase = getIt<GetAllUsersUseCase>();
final searchUsersUseCase = getIt<SearchUsersUseCase>();

// Usar
final users = await getAllUsersUseCase();
final results = await searchUsersUseCase('John');
```

---

## Testes

### Como Testar

```bash
# Rodar todos os testes
flutter test

# Testes específicos (quando implementados)
flutter test test/presentation/providers/users_provider_test.dart
flutter test test/data/datasources/remote_users_datasource_test.dart
```

### Testes Sugeridos

- [ ] UsersProvider
  - Testar loadAllUsers
  - Testar searchUsers
  - Testar clearSearch
  - Testar estados (loading, error, success)

- [ ] RemoteUsersDatasource
  - Testar getAllUsers
  - Testar getUserById
  - Testar searchUsersByName
  - Testar tratamento de erros

- [ ] UserRepositoryImpl
  - Testar delegação para datasource
  - Testar tratamento de erros

---

## Endpoints Disponíveis

Base URL: `https://jsonplaceholder.typicode.com`

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/users` | Lista todos usuários (10) |
| GET | `/users/{id}` | Busca usuário por ID |
| POST | `/users` | Cria usuário (simulado) |
| PUT | `/users/{id}` | Atualiza usuário (simulado) |
| DELETE | `/users/{id}` | Deleta usuário (simulado) |

**Nota:** JSONPlaceholder simula operações POST/PUT/DELETE mas não persiste dados.

---

## Dependency Injection

Todos os componentes estão registrados no GetIt:

```dart
// ApiGateway
getIt.registerLazySingleton<ApiGateway>(() => ApiGateway());

// Datasource
getIt.registerLazySingleton<RemoteUsersDatasource>(
  () => RemoteUsersDatasource(getIt()),
);

// Repository
getIt.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(getIt()),
);

// Use Cases
getIt.registerFactory(() => GetAllUsersUseCase(getIt()));
getIt.registerFactory(() => SearchUsersUseCase(getIt()));
```

---

## Próximos Passos

### Melhorias Sugeridas

1. **Cache Local**
   - Implementar Hive ou SQLite
   - Cache dos usuários
   - Sincronização offline

2. **Retry Logic**
   - Tentar novamente em caso de erro
   - Exponential backoff

3. **Timeout**
   - Configurar timeout para requests
   - Feedback ao usuário

4. **Paginação**
   - Lazy loading
   - Infinite scroll

5. **Filtros Avançados**
   - Por empresa
   - Por cidade
   - Por email domain

6. **Outros Endpoints**
   - Posts (`/posts`)
   - Comments (`/comments`)
   - Albums (`/albums`)
   - Photos (`/photos`)
   - Todos (`/todos`)

---

## Referências

- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - API de teste gratuita
- [HTTP Package](https://pub.dev/packages/http) - Cliente HTTP para Dart
- [GetIt](https://pub.dev/packages/get_it) - Service Locator para DI
- [Provider](https://pub.dev/packages/provider) - State Management

---

**Última atualização:** Outubro 2025  
**Versão:** 1.0.0  
**Status:** ✅ Implementado e Funcionando

