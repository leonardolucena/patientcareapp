import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/repositories/clinic_repository.dart';

/// Mock manual do ClinicRepository para testes
class MockClinicRepository implements ClinicRepository {
  List<ClinicModel>? _getAllClinicsResult;
  Exception? _getAllClinicsException;
  
  List<ClinicModel>? _searchClinicsResult;
  Exception? _searchClinicsException;

  void setupGetAllClinics(List<ClinicModel> result) {
    _getAllClinicsResult = result;
  }

  void setupGetAllClinicsError(Exception exception) {
    _getAllClinicsException = exception;
  }

  void setupSearchClinics(List<ClinicModel> result) {
    _searchClinicsResult = result;
  }

  @override
  Future<List<ClinicModel>> getAllClinics() async {
    if (_getAllClinicsException != null) {
      throw _getAllClinicsException!;
    }
    return _getAllClinicsResult ?? [];
  }

  @override
  Future<List<ClinicModel>> getNearbyClinics(
    double latitude,
    double longitude,
  ) async {
    return _getAllClinicsResult ?? [];
  }

  @override
  Future<ClinicModel?> getClinicById(String id) async {
    return null;
  }

  @override
  Future<List<ClinicModel>> searchClinicsByName(String name) async {
    if (_searchClinicsException != null) {
      throw _searchClinicsException!;
    }
    return _searchClinicsResult ?? [];
  }

  void reset() {
    _getAllClinicsResult = null;
    _getAllClinicsException = null;
    _searchClinicsResult = null;
    _searchClinicsException = null;
  }
}

