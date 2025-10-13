import 'package:patientcareapp/data/models/clinic_model.dart';

/// Interface do repositório de clínicas
/// Segue o Dependency Inversion Principle (DIP) - depende de abstração
abstract class ClinicRepository {
  /// Retorna todas as clínicas
  Future<List<ClinicModel>> getAllClinics();

  /// Retorna clínicas próximas a uma localização
  Future<List<ClinicModel>> getNearbyClinics(double latitude, double longitude);

  /// Retorna uma clínica pelo ID
  Future<ClinicModel?> getClinicById(String id);

  /// Busca clínicas por nome
  Future<List<ClinicModel>> searchClinicsByName(String name);
}

