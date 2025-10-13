import 'package:flutter/foundation.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/review_model.dart';
import 'package:patientcareapp/domain/usecases/get_doctor_reviews_usecase.dart';

/// Provider para gerenciar o estado das avaliações
/// Segue o Single Responsibility Principle (SRP)
/// Usa os Use Cases para lógica de negócio (DIP)
class ReviewsProvider extends ChangeNotifier {
  // Use Cases injetados via DI
  final GetDoctorReviewsUseCase _getDoctorReviewsUseCase = 
      getIt<GetDoctorReviewsUseCase>();

  // Estado
  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  String? _error;
  String? _currentDoctorId;

  // Getters
  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentDoctorId => _currentDoctorId;

  /// Carrega as avaliações de um médico
  Future<void> loadReviewsForDoctor(String doctorId) async {
    if (_currentDoctorId == doctorId && _reviews.isNotEmpty) {
      // Já carregou este médico
      return;
    }

    _currentDoctorId = doctorId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _getDoctorReviewsUseCase(doctorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar avaliações: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calcula a média das avaliações
  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    final sum = _reviews.fold<double>(0.0, (prev, review) => prev + review.rating);
    return sum / _reviews.length;
  }

  /// Conta quantas avaliações têm cada número de estrelas
  Map<int, int> get ratingDistribution {
    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in _reviews) {
      final stars = review.rating.floor();
      distribution[stars] = (distribution[stars] ?? 0) + 1;
    }
    return distribution;
  }

  /// Limpa os dados
  void clear() {
    _reviews = [];
    _currentDoctorId = null;
    _error = null;
    notifyListeners();
  }
}

