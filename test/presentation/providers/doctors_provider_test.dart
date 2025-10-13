import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/presentation/providers/doctors_provider.dart';
import 'package:patientcareapp/core/di/injection_container.dart';

/// Testes do DoctorsProvider
/// 
/// Testa o gerenciamento de estado da lista de médicos
void main() {
  late DoctorsProvider provider;

  setUpAll(() async {
    // Inicializa DI para os testes
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
      expect(provider.doctors.length, 80); // 80 médicos
      expect(provider.error, isNull);
    });

    test('deve filtrar médicos por especialidade', () async {
      // Arrange
      await provider.loadAllDoctors();

      // Act
      await provider.filterBySpecialty('Cardiologia');

      // Assert
      expect(provider.selectedSpecialty, 'Cardiologia');
      expect(provider.doctors.length, 10); // 10 cardiologistas
      expect(
        provider.doctors.every((doc) => doc.specialty == 'Cardiologia'),
        isTrue,
      );
    });

    test('deve buscar médicos por nome', () async {
      // Arrange
      await provider.loadAllDoctors();

      // Act
      await provider.searchDoctors('Carlos');

      // Assert
      expect(provider.doctors, isNotEmpty);
      expect(
        provider.doctors.every((doc) => doc.name.contains('Carlos')),
        isTrue,
      );
    });

    test('deve retornar todos médicos quando busca está vazia', () async {
      // Arrange
      await provider.loadAllDoctors();
      await provider.searchDoctors('Carlos'); // Primeiro filtra

      // Act
      await provider.searchDoctors(''); // Depois limpa

      // Assert
      expect(provider.doctors.length, 80); // Volta para todos
    });

    test('deve combinar filtro de especialidade com busca por nome', () async {
      // Arrange
      await provider.loadAllDoctors();
      await provider.filterBySpecialty('Cardiologia');

      // Act
      await provider.searchDoctors('Carlos');

      // Assert
      expect(provider.doctors, isNotEmpty);
      expect(
        provider.doctors.every(
          (doc) => doc.specialty == 'Cardiologia' && doc.name.contains('Carlos'),
        ),
        isTrue,
      );
    });

    test('deve limpar todos os filtros', () async {
      // Arrange
      await provider.loadAllDoctors();
      await provider.filterBySpecialty('Cardiologia');
      await provider.searchDoctors('Carlos');

      // Act
      provider.clearFilters();

      // Assert
      expect(provider.selectedSpecialty, 'Todos');
      expect(provider.searchQuery, isEmpty);
      expect(provider.doctors.length, 80);
    });
  });
}

