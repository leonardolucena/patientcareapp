import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

/// Use Case para obter médicos por especialidade
/// Segue o Single Responsibility Principle (SRP)
class GetDoctorsBySpecialtyUseCase {
  final DoctorRepository _repository;

  GetDoctorsBySpecialtyUseCase(this._repository);

  Future<List<DoctorModel>> call(String specialty) async {
    return await _repository.getDoctorsBySpecialty(specialty);
  }
}

