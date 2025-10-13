import 'package:flutter_test/flutter_test.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_doctors_usecase.dart';
import '../../mocks/mock_doctor_repository.dart';

/// Testes unitários para GetAllDoctorsUseCase
/// 
/// Objetivo: Verificar se o use case chama o repository corretamente
/// e retorna os dados esperados
void main() {
  late GetAllDoctorsUseCase useCase;
  late MockDoctorRepository mockRepository;

  setUp(() {
    mockRepository = MockDoctorRepository();
    useCase = GetAllDoctorsUseCase(mockRepository);
  });

  tearDown(() {
    mockRepository.reset();
  });

  group('GetAllDoctorsUseCase', () {
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
      const DoctorModel(
        id: '2',
        name: 'Dra. Test 2',
        specialty: 'Dermatologia',
        rating: 4.8,
        experience: '15 anos',
        price: 'R\$ 250',
        image: '👩‍⚕️',
      ),
    ];

    test('deve retornar lista de médicos quando chamado com sucesso', () async {
      // Arrange - Configurar o mock para retornar dados
      mockRepository.setupGetAllDoctors(tDoctors);

      // Act - Executar o use case
      final result = await useCase();

      // Assert - Verificar o resultado
      expect(result, tDoctors);
      expect(result.length, 2);
      expect(result[0].name, 'Dr. Test');
      expect(result[1].specialty, 'Dermatologia');
    });

    test('deve retornar lista vazia quando não há médicos', () async {
      // Arrange
      mockRepository.setupGetAllDoctors([]);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
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
