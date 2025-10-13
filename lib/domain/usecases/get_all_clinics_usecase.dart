import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';

/// Use Case para obter todas as clínicas
/// Segue o Single Responsibility Principle (SRP)
class GetAllClinicsUseCase {
  final ClinicRepository _repository;

  GetAllClinicsUseCase(this._repository);

  Future<List<ClinicModel>> call() async {
    return await _repository.getAllClinics();
  }
}

