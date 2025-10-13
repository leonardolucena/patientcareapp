import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/usecases/search_doctors_usecase.dart';
import '../../mocks/mock_doctor_repository.dart';

/// Testes unitários para SearchDoctorsUseCase
void main() {
  late SearchDoctorsUseCase useCase;
  late MockDoctorRepository mockRepository;

  setUp(() {
    mockRepository = MockDoctorRepository();
    useCase = SearchDoctorsUseCase(mockRepository);
  });

  tearDown(() {
    mockRepository.reset();
  });

  group('SearchDoctorsUseCase', () {
    final tDoctors = [
      const DoctorModel(
        id: '1',
        name: 'Dr. Carlos Silva',
        specialty: 'Cardiologia',
        rating: 4.5,
        experience: '10 anos',
        price: 'R\$ 200',
        image: '👨‍⚕️',
      ),
      const DoctorModel(
        id: '2',
        name: 'Dra. Ana Santos',
        specialty: 'Dermatologia',
        rating: 4.8,
        experience: '15 anos',
        price: 'R\$ 250',
        image: '👩‍⚕️',
      ),
    ];

    test('deve buscar médicos por nome quando query não está vazia', () async {
      // Arrange
      const tQuery = 'Carlos';
      final tFilteredDoctors = [tDoctors[0]];
      
      mockRepository.setupSearchDoctorsByName(tFilteredDoctors);

      // Act
      final result = await useCase(tQuery);

      // Assert
      expect(result, tFilteredDoctors);
      expect(result.length, 1);
      expect(result[0].name, contains('Carlos'));
    });

    test('deve retornar todos os médicos quando query está vazia', () async {
      // Arrange
      const tQuery = '';
      
      mockRepository.setupGetAllDoctors(tDoctors);

      // Act
      final result = await useCase(tQuery);

      // Assert
      expect(result, tDoctors);
      expect(result.length, 2);
    });

    test('deve retornar lista vazia quando nenhum médico corresponde à busca', () async {
      // Arrange
      const tQuery = 'Inexistente';
      
      mockRepository.setupSearchDoctorsByName([]);

      // Act
      final result = await useCase(tQuery);

      // Assert
      expect(result, isEmpty);
    });

    test('deve propagar exceção do repository', () async {
      // Arrange
      const tQuery = 'Error';
      
      mockRepository.setupSearchDoctorsByNameError(
        Exception('Erro na busca'),
      );

      // Act & Assert
      expect(
        () => useCase(tQuery),
        throwsA(isA<Exception>()),
      );
    });
  });
}
