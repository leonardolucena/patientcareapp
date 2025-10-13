# 📝 Exemplos de Testes - PatientCare App

Este documento contém exemplos práticos de como os testes foram implementados no projeto.

## 📋 Índice

1. [Teste de Use Case](#teste-de-use-case)
2. [Teste de Repository](#teste-de-repository)
3. [Teste de Provider](#teste-de-provider)
4. [Teste de Widget](#teste-de-widget)
5. [Criando um Mock Manual](#criando-um-mock-manual)

---

## 1. Teste de Use Case

### Exemplo: GetAllDoctorsUseCase

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_doctors_usecase.dart';
import '../../mocks/mock_doctor_repository.dart';

void main() {
  late GetAllDoctorsUseCase useCase;
  late MockDoctorRepository mockRepository;

  // setUp é executado antes de cada teste
  setUp(() {
    mockRepository = MockDoctorRepository();
    useCase = GetAllDoctorsUseCase(mockRepository);
  });

  // tearDown é executado depois de cada teste
  tearDown(() {
    mockRepository.reset();
  });

  group('GetAllDoctorsUseCase', () {
    // Dados de teste
    final tDoctors = [
      const DoctorModel(
        id: '1',
        name: 'Dr. Test',
        specialty: 'Cardiologia',
        rating: 4.5,
        experience: '10 anos',
        price: 'R\$ 200',
        image: '👨‍⚕️',
      ),
    ];

    test('deve retornar lista de médicos quando chamado com sucesso', () async {
      // Arrange - Configurar o mock
      mockRepository.setupGetAllDoctors(tDoctors);

      // Act - Executar o use case
      final result = await useCase();

      // Assert - Verificar o resultado
      expect(result, tDoctors);
      expect(result.length, 1);
      expect(result[0].name, 'Dr. Test');
    });

    test('deve propagar exceção quando repository lança erro', () async {
      // Arrange
      mockRepository.setupGetAllDoctorsError(
        Exception('Erro ao buscar médicos'),
      );

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
```

**O que estamos testando:**
- ✅ Se o use case retorna os dados corretos
- ✅ Se o use case propaga exceções
- ✅ Se o use case chama o repository corretamente

---

## 2. Teste de Repository

### Exemplo: DoctorRepositoryImpl

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/repositories/doctor_repository_impl.dart';

void main() {
  late DoctorRepositoryImpl repository;
  late LocalDoctorsDatasource datasource;

  setUp(() {
    datasource = LocalDoctorsDatasource();
    repository = DoctorRepositoryImpl(datasource);
  });

  group('DoctorRepositoryImpl', () {
    test('deve retornar todos os médicos do datasource', () async {
      // Act
      final result = await repository.getAllDoctors();

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 80); // 80 médicos no datasource
    });

    test('deve filtrar médicos por especialidade', () async {
      // Act
      final result = await repository.getDoctorsBySpecialty('Cardiologia');

      // Assert
      expect(result, isNotEmpty);
      expect(result.every((doc) => doc.specialty == 'Cardiologia'), isTrue);
    });

    test('deve retornar médico por ID', () async {
      // Act
      final result = await repository.getDoctorById('doc_001');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'doc_001');
    });
  });
}
```

**O que estamos testando:**
- ✅ Se o repository acessa o datasource corretamente
- ✅ Se os filtros funcionam como esperado
- ✅ Se a busca por ID funciona

---

## 3. Teste de Provider

### Exemplo: DoctorsProvider

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/presentation/providers/doctors_provider.dart';
import 'package:patientcareapp/core/di/injection_container.dart';

void main() {
  late DoctorsProvider provider;

  setUpAll(() async {
    // Inicializa DI uma vez para todos os testes
    await initializeDependencies();
  });

  setUp(() {
    provider = DoctorsProvider();
  });

  group('DoctorsProvider', () {
    test('deve inicializar com estado vazio', () {
      // Assert
      expect(provider.doctors, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.selectedSpecialty, 'Todos');
    });

    test('deve carregar todos os médicos com sucesso', () async {
      // Act
      await provider.loadAllDoctors();

      // Assert
      expect(provider.isLoading, isFalse);
      expect(provider.doctors, isNotEmpty);
      expect(provider.doctors.length, 80);
      expect(provider.error, isNull);
    });

    test('deve filtrar médicos por especialidade', () async {
      // Arrange
      await provider.loadAllDoctors();

      // Act
      await provider.filterBySpecialty('Cardiologia');

      // Assert
      expect(provider.selectedSpecialty, 'Cardiologia');
      expect(provider.doctors.length, 10);
      expect(
        provider.doctors.every((doc) => doc.specialty == 'Cardiologia'),
        isTrue,
      );
    });

    test('deve combinar filtros', () async {
      // Arrange
      await provider.loadAllDoctors();
      await provider.filterBySpecialty('Cardiologia');

      // Act
      await provider.searchDoctors('Carlos');

      // Assert
      expect(
        provider.doctors.every(
          (doc) => doc.specialty == 'Cardiologia' && 
                   doc.name.contains('Carlos'),
        ),
        isTrue,
      );
    });
  });
}
```

**O que estamos testando:**
- ✅ Estado inicial
- ✅ Carregamento de dados
- ✅ Filtros individuais
- ✅ Combinação de filtros
- ✅ Loading states

---

## 4. Teste de Widget

### Exemplo: DoctorCardWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/presentation/widgets/doctor_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  late DoctorModel testDoctor;

  setUp(() {
    testDoctor = const DoctorModel(
      id: '1',
      name: 'Dr. Test',
      specialty: 'Cardiologia',
      rating: 4.5,
      experience: '10 anos',
      price: 'R\$ 200',
      image: '👨‍⚕️',
    );
  });

  Widget createWidgetUnderTest(DoctorModel doctor, VoidCallback onTap) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      home: Scaffold(
        body: DoctorCardWidget(
          doctor: doctor,
          onTap: onTap,
        ),
      ),
    );
  }

  group('DoctorCardWidget', () {
    testWidgets('deve exibir informações básicas', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest(testDoctor, () {}));

      // Assert
      expect(find.text('Dr. Test'), findsOneWidget);
      expect(find.text('👨‍⚕️'), findsOneWidget);
      expect(find.text('10 anos'), findsOneWidget);
      expect(find.text('R\$ 200'), findsOneWidget);
    });

    testWidgets('deve ser clicável', (tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(testDoctor, () => tapped = true),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
```

**O que estamos testando:**
- ✅ Renderização de dados
- ✅ Interações do usuário
- ✅ Callbacks funcionando
- ✅ Ícones e textos presentes

---

## 5. Criando um Mock Manual

### Exemplo: MockDoctorRepository

```dart
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

class MockDoctorRepository implements DoctorRepository {
  // Variáveis para armazenar resultados mockados
  List<DoctorModel>? _getAllDoctorsResult;
  Exception? _getAllDoctorsException;

  // Métodos para configurar o mock
  void setupGetAllDoctors(List<DoctorModel> result) {
    _getAllDoctorsResult = result;
  }

  void setupGetAllDoctorsError(Exception exception) {
    _getAllDoctorsException = exception;
  }

  // Implementação dos métodos do repository
  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    if (_getAllDoctorsException != null) {
      throw _getAllDoctorsException!;
    }
    return _getAllDoctorsResult ?? [];
  }

  // Método para limpar o mock entre testes
  void reset() {
    _getAllDoctorsResult = null;
    _getAllDoctorsException = null;
  }
}
```

**Como usar o mock:**

```dart
test('exemplo de uso do mock', () async {
  // Arrange
  final mock = MockDoctorRepository();
  final useCase = GetAllDoctorsUseCase(mock);
  
  // Configurar o mock para retornar dados
  mock.setupGetAllDoctors([
    const DoctorModel(
      id: '1',
      name: 'Dr. Test',
      // ... outros campos
    ),
  ]);

  // Act
  final result = await useCase();

  // Assert
  expect(result, isNotEmpty);
});
```

---

## 📊 Padrões de Matchers

### Matchers Comuns

```dart
// Igualdade
expect(result, equals(expected));
expect(result, isNotNull);
expect(result, isNull);

// Tipos
expect(result, isA<DoctorModel>());
expect(result, isInstanceOf<Exception>());

// Coleções
expect(result, isEmpty);
expect(result, isNotEmpty);
expect(result.length, 5);
expect(result, contains('valor'));

// Booleanos
expect(result, isTrue);
expect(result, isFalse);

// Exceções
expect(() => funcao(), throwsException);
expect(() => funcao(), throwsA(isA<Exception>()));

// Widgets (WidgetTester)
expect(find.text('Hello'), findsOneWidget);
expect(find.byIcon(Icons.star), findsNothing);
expect(find.byType(Container), findsWidgets);
```

---

## 🎯 Boas Práticas

### 1. Nomes Descritivos
```dart
✅ test('deve retornar lista de médicos quando chamado com sucesso', () {});
❌ test('teste1', () {});
```

### 2. Padrão AAA
```dart
test('exemplo', () async {
  // Arrange - Preparar
  final mock = MockRepository();
  final useCase = UseCase(mock);

  // Act - Executar
  final result = await useCase();

  // Assert - Verificar
  expect(result, isNotNull);
});
```

### 3. Um Assert Principal
```dart
✅ test('deve retornar não vazio', () {
  expect(result, isNotEmpty);
});

❌ test('deve validar tudo', () {
  expect(result, isNotEmpty);
  expect(result.length, 5);
  expect(result[0].name, 'Test');
  expect(result[0].age, 30);
  // Muitas asserções diferentes
});
```

### 4. Isolamento
```dart
// Use setUp para inicialização
setUp(() {
  repository = MockRepository();
});

// Use tearDown para limpeza
tearDown(() {
  repository.reset();
});
```

---

## 🚀 Executando Testes

### Teste específico
```bash
flutter test test/domain/usecases/get_all_doctors_usecase_test.dart
```

### Teste de um arquivo com verbose
```bash
flutter test test/domain/usecases/get_all_doctors_usecase_test.dart --reporter expanded
```

### Todos os testes de uma pasta
```bash
flutter test test/domain/usecases/
```

### Com cobertura
```bash
flutter test --coverage
```

---

## 📚 Recursos

- [Flutter Testing Docs](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Effective Dart Testing](https://dart.dev/guides/language/effective-dart/testing)

---

**Última atualização:** Outubro 2025  
**Total de Exemplos:** 5 categorias  
**Status:** ✅ Documentação completa

