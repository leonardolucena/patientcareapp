import 'package:patientcareapp/data/datasources/local_doctors_datasource.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

/// Implementação do repositório de médicos
/// Segue o Dependency Inversion Principle (DIP)
class DoctorRepositoryImpl implements DoctorRepository {
  final LocalDoctorsDatasource _datasource;

  DoctorRepositoryImpl(this._datasource);

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    // Simulando delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getAllDoctors();
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getDoctorsBySpecialty(specialty);
  }

  @override
  Future<List<DoctorModel>> searchDoctorsByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.searchDoctorsByName(name);
  }

  @override
  Future<DoctorModel?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.getDoctorById(id);
  }

  @override
  Future<List<DoctorModel>> getDoctorsByClinic(String clinicId) async {
    // Por enquanto retorna todos os médicos
    // Em produção, filtraria por clínica
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getAllDoctors();
  }
}

