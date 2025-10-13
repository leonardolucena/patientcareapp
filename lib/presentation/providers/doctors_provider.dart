import 'package:flutter/foundation.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_doctors_usecase.dart';
import 'package:patientcareapp/domain/usecases/get_doctors_by_specialty_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_doctors_usecase.dart';

/// Provider para gerenciar o estado da lista de médicos
/// Segue o Single Responsibility Principle (SRP)
/// Usa os Use Cases para lógica de negócio (DIP)
class DoctorsProvider extends ChangeNotifier {
  // Use Cases injetados via DI
  final GetAllDoctorsUseCase _getAllDoctorsUseCase = getIt<GetAllDoctorsUseCase>();
  final GetDoctorsBySpecialtyUseCase _getDoctorsBySpecialtyUseCase = 
      getIt<GetDoctorsBySpecialtyUseCase>();
  final SearchDoctorsUseCase _searchDoctorsUseCase = getIt<SearchDoctorsUseCase>();

  // Estado
  List<DoctorModel> _doctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = false;
  String? _error;
  String _selectedSpecialty = 'Todos';
  String _searchQuery = '';

  // Getters
  List<DoctorModel> get doctors => _filteredDoctors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedSpecialty => _selectedSpecialty;
  String get searchQuery => _searchQuery;

  /// Carrega todos os médicos
  Future<void> loadAllDoctors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _doctors = await _getAllDoctorsUseCase();
      _filteredDoctors = _doctors;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar médicos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filtra médicos por especialidade
  Future<void> filterBySpecialty(String specialty) async {
    _selectedSpecialty = specialty;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (specialty == 'Todos') {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors = await _getDoctorsBySpecialtyUseCase(specialty);
      }
      
      // Aplica filtro de busca se houver
      if (_searchQuery.isNotEmpty) {
        _applySearchFilter();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao filtrar médicos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca médicos por nome
  Future<void> searchDoctors(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      // Se a busca está vazia, volta para o filtro de especialidade
      if (_selectedSpecialty == 'Todos') {
        _filteredDoctors = _doctors;
      } else {
        await filterBySpecialty(_selectedSpecialty);
      }
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final searchResults = await _searchDoctorsUseCase(query);
      
      // Aplica filtro de especialidade se houver
      if (_selectedSpecialty != 'Todos') {
        _filteredDoctors = searchResults
            .where((doctor) => doctor.specialty == _selectedSpecialty)
            .toList();
      } else {
        _filteredDoctors = searchResults;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar médicos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Aplica filtro de busca na lista atual
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      return;
    }
    
    final lowerQuery = _searchQuery.toLowerCase();
    _filteredDoctors = _filteredDoctors
        .where((doctor) => doctor.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Limpa todos os filtros
  void clearFilters() {
    _selectedSpecialty = 'Todos';
    _searchQuery = '';
    _filteredDoctors = _doctors;
    notifyListeners();
  }
}

