import 'package:flutter/foundation.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/clinic_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_clinics_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_clinics_usecase.dart';

/// Provider para gerenciar o estado da lista de clínicas
/// Segue o Single Responsibility Principle (SRP)
/// Usa os Use Cases para lógica de negócio (DIP)
class ClinicsProvider extends ChangeNotifier {
  // Use Cases injetados via DI
  final GetAllClinicsUseCase _getAllClinicsUseCase = getIt<GetAllClinicsUseCase>();
  final SearchClinicsUseCase _searchClinicsUseCase = getIt<SearchClinicsUseCase>();

  // Estado
  List<ClinicModel> _clinics = [];
  List<ClinicModel> _filteredClinics = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<ClinicModel> get clinics => _filteredClinics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Carrega todas as clínicas
  Future<void> loadAllClinics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clinics = await _getAllClinicsUseCase();
      _filteredClinics = _clinics;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar clínicas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca clínicas por nome
  Future<void> searchClinics(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredClinics = _clinics;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredClinics = await _searchClinicsUseCase(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar clínicas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa a busca
  void clearSearch() {
    _searchQuery = '';
    _filteredClinics = _clinics;
    notifyListeners();
  }
}

