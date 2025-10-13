import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/repositories/doctor_repository_impl.dart';

/// Testes do DoctorRepositoryImpl
/// 
/// Testa se o repository acessa o datasource corretamente
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
      expect(result.length, 80); // 10 médicos por especialidade x 8 especialidades
      expect(result[0].name, isNotEmpty);
      expect(result[0].specialty, isNotEmpty);
    });

    test('deve filtrar médicos por especialidade', () async {
      // Act
      final result = await repository.getDoctorsBySpecialty('Cardiologia');

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 10); // 10 cardiologistas
      expect(result.every((doc) => doc.specialty == 'Cardiologia'), isTrue);
    });

    test('deve buscar médicos por nome', () async {
      // Act
      final result = await repository.searchDoctorsByName('Carlos');

      // Assert
      expect(result, isNotEmpty);
      expect(result.every((doc) => doc.name.contains('Carlos')), isTrue);
    });

    test('deve retornar médico por ID', () async {
      // Act
      final result = await repository.getDoctorById('doc_001');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'doc_001');
      expect(result.name, 'Dr. Carlos Silva');
    });

    test('deve retornar null quando médico não existe', () async {
      // Act
      final result = await repository.getDoctorById('inexistente');

      // Assert
      expect(result, isNull);
    });
  });
}

