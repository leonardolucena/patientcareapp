# 🧪 Documentação de Testes

Este documento descreve a estrutura e estratégia de testes implementada no projeto PatientCareApp.

## 📊 Cobertura Atual

### Testes Implementados: **29 testes**

- ✅ **Use Cases**: 9 testes
- ✅ **Repositories**: 5 testes  
- ✅ **Providers**: 7 testes
- ✅ **Widgets**: 8 testes

## 🏗️ Estrutura de Testes

```
test/
├── mocks/                          # Mocks manuais reutilizáveis
│   ├── mock_doctor_repository.dart
│   └── mock_clinic_repository.dart
├── domain/
│   └── usecases/                   # Testes de Use Cases
│       ├── get_all_doctors_usecase_test.dart
│       ├── search_doctors_usecase_test.dart
│       └── get_all_clinics_usecase_test.dart
├── data/
│   └── repositories/               # Testes de Repositories
│       └── doctor_repository_impl_test.dart
└── presentation/
    ├── providers/                  # Testes de Providers
    │   └── doctors_provider_test.dart
    └── widgets/                    # Testes de Widgets
        ├── doctor_card_widget_test.dart
        └── specialty_chip_widget_test.dart
```

## 🎯 Estratégia de Testes

### 1. Testes de Use Cases

**Objetivo**: Verificar a lógica de negócio isoladamente

**O que testamos:**
- ✅ Chamadas corretas aos repositories
- ✅ Transformação de dados
- ✅ Tratamento de erros
- ✅ Casos de sucesso e falha

**Exemplo:**
```dart
test('deve retornar lista de médicos quando chamado com sucesso', () async {
  // Arrange - Configurar o mock
  mockRepository.setupGetAllDoctors(tDoctors);

  // Act - Executar o use case
  final result = await useCase();

  // Assert - Verificar o resultado
  expect(result, tDoctors);
});
```

### 2. Testes de Repositories

**Objetivo**: Verificar o acesso correto aos datasources

**O que testamos:**
- ✅ Integração com datasources
- ✅ Filtros e buscas
- ✅ Transformação de dados
- ✅ Casos extremos (null, vazio, etc.)

### 3. Testes de Providers

**Objetivo**: Verificar o gerenciamento de estado

**O que testamos:**
- ✅ Estado inicial
- ✅ Loading states
- ✅ Atualização de dados
- ✅ Filtros e buscas
- ✅ Combinação de filtros
- ✅ Tratamento de erros

### 4. Testes de Widgets

**Objetivo**: Verificar a renderização correta da UI

**O que testamos:**
- ✅ Exibição de dados
- ✅ Interações do usuário
- ✅ Estados visuais (selecionado/não selecionado)
- ✅ Comportamento de callbacks

## 🛠️ Tecnologias de Teste

### Dependências

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4        # Biblioteca de mocking (versão com problemas)
  build_runner: ^2.4.9   # Geração de código (não usado)
```

### Mocks Manuais

Devido a problemas de compatibilidade entre `mockito` e `analyzer`, optamos por criar **mocks manuais** em vez de usar geração automática. 

**Vantagens:**
- ✅ Sem dependências de geração de código
- ✅ Mais controle sobre o comportamento
- ✅ Fácil manutenção
- ✅ Sem problemas de versão

**Exemplo de Mock Manual:**
```dart
class MockDoctorRepository implements DoctorRepository {
  List<DoctorModel>? _getAllDoctorsResult;
  Exception? _getAllDoctorsException;
  
  void setupGetAllDoctors(List<DoctorModel> result) {
    _getAllDoctorsResult = result;
  }

  void setupGetAllDoctorsError(Exception exception) {
    _getAllDoctorsException = exception;
  }

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    if (_getAllDoctorsException != null) {
      throw _getAllDoctorsException!;
    }
    return _getAllDoctorsResult ?? [];
  }
}
```

## 🚀 Executando os Testes

### Executar todos os testes
```bash
flutter test
```

### Executar teste específico
```bash
flutter test test/domain/usecases/get_all_doctors_usecase_test.dart
```

### Executar testes com cobertura
```bash
flutter test --coverage
```

### Ver relatório de cobertura (requer lcov)
```bash
# Instalar lcov (macOS)
brew install lcov

# Gerar relatório HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir relatório
open coverage/html/index.html
```

## 📝 Padrões de Nomenclatura

### Arquivos de Teste
- Use o sufixo `_test.dart`
- Mantenha a mesma estrutura de pastas do código fonte
- Exemplo: `lib/domain/usecases/get_all_doctors_usecase.dart` → `test/domain/usecases/get_all_doctors_usecase_test.dart`

### Nomes de Testes
Use descrições claras em português:
- ✅ `'deve retornar lista de médicos quando chamado com sucesso'`
- ✅ `'deve propagar exceção quando repository lança erro'`
- ✅ `'deve exibir informações básicas do médico'`

### Estrutura AAA (Arrange-Act-Assert)

Todos os testes seguem o padrão AAA:

```dart
test('descrição do teste', () async {
  // Arrange - Preparar dados e mocks
  mockRepository.setupGetAllDoctors(tDoctors);

  // Act - Executar a ação sendo testada
  final result = await useCase();

  // Assert - Verificar o resultado
  expect(result, tDoctors);
});
```

## 🎨 Boas Práticas Implementadas

### 1. Isolamento
- ✅ Cada teste é independente
- ✅ Use `setUp()` para inicialização
- ✅ Use `tearDown()` para limpeza
- ✅ Não compartilhe estado entre testes

### 2. Clareza
- ✅ Um assert principal por teste
- ✅ Nomes descritivos
- ✅ Comentários explicativos quando necessário

### 3. Cobertura
- ✅ Testes de casos de sucesso
- ✅ Testes de casos de erro
- ✅ Testes de casos extremos (edge cases)
- ✅ Testes de validação de dados

### 4. Performance
- ✅ Testes rápidos (< 1 segundo cada)
- ✅ Sem dependências externas (API, banco de dados)
- ✅ Mocks para todas as dependências

## 🔄 Próximos Passos

### Testes Pendentes

1. **Testes de Integração**
   - Testar fluxos completos
   - Testar navegação entre telas
   - Testar integração entre componentes

2. **Testes E2E (End-to-End)**
   - Testar o app completo
   - Usar `integration_test` package
   - Simular interações reais do usuário

3. **Aumentar Cobertura**
   - Adicionar testes para `appointment_confirmation_screen.dart`
   - Adicionar testes para demais repositories
   - Adicionar testes para demais use cases
   - Meta: > 80% de cobertura

4. **Testes de Performance**
   - Testar com grandes volumes de dados
   - Testar scroll performance
   - Testar animações

5. **Testes de Acessibilidade**
   - Testar com leitores de tela
   - Testar contraste de cores
   - Testar tamanhos de fonte

## 📚 Recursos Adicionais

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

## 🤝 Contribuindo

Ao adicionar novos testes:

1. Siga a estrutura de pastas existente
2. Use mocks manuais ou crie novos se necessário
3. Siga o padrão AAA
4. Adicione comentários explicativos
5. Execute todos os testes antes de fazer commit
6. Mantenha a cobertura acima de 70%

---

**Última atualização**: Outubro 2025  
**Versão do Flutter**: 3.x  
**Total de Testes**: 29 ✅

