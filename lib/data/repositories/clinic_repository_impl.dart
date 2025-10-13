import 'package:patientcareapp/data/datasources/local_clinics_datasource.dart';
import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';

/// Implementação do repositório de clínicas
/// Segue o Dependency Inversion Principle (DIP)
class ClinicRepositoryImpl implements ClinicRepository {
  final LocalClinicsDatasource _datasource;

  ClinicRepositoryImpl(this._datasource);

  @override
  Future<List<ClinicModel>> getAllClinics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getAllClinics();
  }

  @override
  Future<List<ClinicModel>> getNearbyClinics(
    double latitude,
    double longitude,
  ) async {
    // Em produção, calcularia distância real baseado nas coordenadas
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.getAllClinics();
  }

  @override
  Future<ClinicModel?> getClinicById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.getClinicById(id);
  }

  @override
  Future<List<ClinicModel>> searchClinicsByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.searchClinicsByName(name);
  }
}

