import 'package:patientcareapp/data/models/doctor_model.dart';

/// Interface do repositório de médicos
/// Segue o Dependency Inversion Principle (DIP) - depende de abstração
abstract class DoctorRepository {
  /// Retorna todos os médicos
  Future<List<DoctorModel>> getAllDoctors();

  /// Retorna médicos filtrados por especialidade
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty);

  /// Retorna médicos filtrados por nome
  Future<List<DoctorModel>> searchDoctorsByName(String name);

  /// Retorna um médico pelo ID
  Future<DoctorModel?> getDoctorById(String id);

  /// Retorna médicos de uma clínica
  Future<List<DoctorModel>> getDoctorsByClinic(String clinicId);
}

