import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';

/// Use Case para buscar clínicas por nome
/// Segue o Single Responsibility Principle (SRP)
class SearchClinicsUseCase {
  final ClinicRepository _repository;

  SearchClinicsUseCase(this._repository);

  Future<List<ClinicModel>> call(String name) async {
    if (name.isEmpty) {
      return await _repository.getAllClinics();
    }
    return await _repository.searchClinicsByName(name);
  }
}

