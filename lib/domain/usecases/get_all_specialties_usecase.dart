import 'package:patientcareapp/data/models/specialty_model.dart';
import 'package:patientcareapp/domain/repositories/specialty_repository.dart';

/// Use Case para obter todas as especialidades
/// Segue o Single Responsibility Principle (SRP)
class GetAllSpecialtiesUseCase {
  final SpecialtyRepository _repository;

  GetAllSpecialtiesUseCase(this._repository);

  Future<List<SpecialtyModel>> call() async {
    return await _repository.getAllSpecialties();
  }
}

