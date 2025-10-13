import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

/// Use Case para obter todos os médicos
/// Segue o Single Responsibility Principle (SRP)
class GetAllDoctorsUseCase {
  final DoctorRepository _repository;

  GetAllDoctorsUseCase(this._repository);

  Future<List<DoctorModel>> call() async {
    return await _repository.getAllDoctors();
  }
}

