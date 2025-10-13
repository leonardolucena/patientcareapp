import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/repositories/doctor_repository_impl.dart';
import '../../mocks/mock_remote_users_datasource.dart';

/// Testes do DoctorRepositoryImpl
/// 
/// Testa se o repository acessa o datasource corretamente
void main() {
  late DoctorRepositoryImpl repository;
  late LocalDoctorsDatasource datasource;
  late MockRemoteUsersDatasource mockRemoteUsers;

  setUp(() {
    mockRemoteUsers = MockRemoteUsersDatasource();
    datasource = LocalDoctorsDatasource(mockRemoteUsers);
    repository = DoctorRepositoryImpl(datasource);
  });

  group('DoctorRepositoryImpl', () {
    test('deve retornar todos os médicos do datasource', () async {
      // Act
      final result = await repository.getAllDoctors();

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 40); // 5 médicos por especialidade x 8 especialidades
      expect(result[0].name, isNotEmpty);
      expect(result[0].specialty, isNotEmpty);
    });

    test('deve filtrar médicos por especialidade', () async {
      // Act
      final result = await repository.getDoctorsBySpecialty('Cardiologia');

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 5); // 5 cardiologistas
      expect(result.every((doc) => doc.specialty == 'Cardiologia'), isTrue);
    });

    test('deve buscar médicos por nome', () async {
      // Act - Busca por "Leanne" que é o primeiro usuário da API
      final result = await repository.searchDoctorsByName('Leanne');

      // Assert
      expect(result, isNotEmpty);
      expect(result.every((doc) => doc.name.contains('Leanne')), isTrue);
    });

    test('deve retornar médico por ID', () async {
      // Act - O primeiro médico terá ID baseado no primeiro usuário da API
      final allDoctors = await repository.getAllDoctors();
      final firstDoctor = allDoctors.first;
      
      final result = await repository.getDoctorById(firstDoctor.id);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, firstDoctor.id);
    });

    test('deve retornar null quando médico não existe', () async {
      // Act
      final result = await repository.getDoctorById('inexistente');

      // Assert
      expect(result, isNull);
    });
  });
}
