import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/repositories/doctor_repository.dart';

/// Mock manual do DoctorRepository para testes
/// Mais simples que usar Mockito e sem problemas de versão
class MockDoctorRepository implements DoctorRepository {
  List<DoctorModel>? _getAllDoctorsResult;
  Exception? _getAllDoctorsException;
  
  List<DoctorModel>? _getDoctorsBySpecialtyResult;
  Exception? _getDoctorsBySpecialtyException;
  
  List<DoctorModel>? _searchDoctorsByNameResult;
  Exception? _searchDoctorsByNameException;
  
  DoctorModel? _getDoctorByIdResult;
  Exception? _getDoctorByIdException;

  // Configuração de respostas
  void setupGetAllDoctors(List<DoctorModel> result) {
    _getAllDoctorsResult = result;
  }

  void setupGetAllDoctorsError(Exception exception) {
    _getAllDoctorsException = exception;
  }

  void setupGetDoctorsBySpecialty(List<DoctorModel> result) {
    _getDoctorsBySpecialtyResult = result;
  }

  void setupSearchDoctorsByName(List<DoctorModel> result) {
    _searchDoctorsByNameResult = result;
  }

  void setupSearchDoctorsByNameError(Exception exception) {
    _searchDoctorsByNameException = exception;
  }

  void setupGetDoctorById(DoctorModel result) {
    _getDoctorByIdResult = result;
  }

  // Implementação dos métodos
  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    if (_getAllDoctorsException != null) {
      throw _getAllDoctorsException!;
    }
    return _getAllDoctorsResult ?? [];
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    if (_getDoctorsBySpecialtyException != null) {
      throw _getDoctorsBySpecialtyException!;
    }
    return _getDoctorsBySpecialtyResult ?? [];
  }

  @override
  Future<List<DoctorModel>> searchDoctorsByName(String name) async {
    if (_searchDoctorsByNameException != null) {
      throw _searchDoctorsByNameException!;
    }
    return _searchDoctorsByNameResult ?? [];
  }

  @override
  Future<DoctorModel?> getDoctorById(String id) async {
    if (_getDoctorByIdException != null) {
      throw _getDoctorByIdException!;
    }
    return _getDoctorByIdResult;
  }

  @override
  Future<List<DoctorModel>> getDoctorsByClinic(String clinicId) async {
    return [];
  }

  // Reset para novos testes
  void reset() {
    _getAllDoctorsResult = null;
    _getAllDoctorsException = null;
    _getDoctorsBySpecialtyResult = null;
    _getDoctorsBySpecialtyException = null;
    _searchDoctorsByNameResult = null;
    _searchDoctorsByNameException = null;
    _getDoctorByIdResult = null;
    _getDoctorByIdException = null;
  }
}

