import 'package:patientcareapp/data/models/specialty_model.dart';

/// Interface do repositório de especialidades
/// Segue o Dependency Inversion Principle (DIP) - depende de abstração
abstract class SpecialtyRepository {
  /// Retorna todas as especialidades disponíveis
  Future<List<SpecialtyModel>> getAllSpecialties();

  /// Retorna uma especialidade pelo ID
  Future<SpecialtyModel?> getSpecialtyById(String id);

  /// Retorna uma especialidade pela chave de nome
  Future<SpecialtyModel?> getSpecialtyByNameKey(String nameKey);
}

