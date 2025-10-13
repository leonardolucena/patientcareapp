import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_clinics_usecase.dart';
import '../../mocks/mock_clinic_repository.dart';

/// Testes unitários para GetAllClinicsUseCase
void main() {
  late GetAllClinicsUseCase useCase;
  late MockClinicRepository mockRepository;

  setUp(() {
    mockRepository = MockClinicRepository();
    useCase = GetAllClinicsUseCase(mockRepository);
  });

  tearDown(() {
    mockRepository.reset();
  });

  group('GetAllClinicsUseCase', () {
    final tClinics = [
      const ClinicModel(
        id: '1',
        name: 'Clínica São Paulo',
        address: 'Av. Paulista, 1000',
        distance: '2.3 km',
        latitude: -23.561684,
        longitude: -46.655981,
      ),
      const ClinicModel(
        id: '2',
        name: 'Hospital Santa Maria',
        address: 'Rua Augusta, 500',
        distance: '3.5 km',
        latitude: -23.561234,
        longitude: -46.654321,
      ),
    ];

    test('deve retornar lista de clínicas quando chamado com sucesso', () async {
      // Arrange
      mockRepository.setupGetAllClinics(tClinics);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tClinics);
      expect(result.length, 2);
      expect(result[0].name, 'Clínica São Paulo');
      expect(result[1].address, 'Rua Augusta, 500');
    });

    test('deve retornar lista vazia quando não há clínicas', () async {
      // Arrange
      mockRepository.setupGetAllClinics([]);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
    });

    test('deve propagar exceção quando repository lança erro', () async {
      // Arrange
      mockRepository.setupGetAllClinicsError(
        Exception('Erro ao buscar clínicas'),
      );

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
