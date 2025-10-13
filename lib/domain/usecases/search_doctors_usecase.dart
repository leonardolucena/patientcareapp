import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

/// Use Case para buscar médicos por nome
/// Segue o Single Responsibility Principle (SRP)
class SearchDoctorsUseCase {
  final DoctorRepository _repository;

  SearchDoctorsUseCase(this._repository);

  Future<List<DoctorModel>> call(String name) async {
    if (name.isEmpty) {
      return await _repository.getAllDoctors();
    }
    return await _repository.searchDoctorsByName(name);
  }
}

