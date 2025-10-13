import 'package:patientcareapp/data/datasources/local_specialties_datasource.dart';
import 'package:patientcareapp/data/models/specialty_model.dart';
import 'package:patientcareapp/domain/repositories/specialty_repository.dart';

/// Implementação do repositório de especialidades
/// Segue o Dependency Inversion Principle (DIP)
class SpecialtyRepositoryImpl implements SpecialtyRepository {
  final LocalSpecialtiesDatasource _datasource;

  SpecialtyRepositoryImpl(this._datasource);

  @override
  Future<List<SpecialtyModel>> getAllSpecialties() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.getAllSpecialties();
  }

  @override
  Future<SpecialtyModel?> getSpecialtyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _datasource.getSpecialtyById(id);
  }

  @override
  Future<SpecialtyModel?> getSpecialtyByNameKey(String nameKey) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _datasource.getSpecialtyByNameKey(nameKey);
  }
}

