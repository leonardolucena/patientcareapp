import 'package:patientcareapp/data/models/review_model.dart';

/// Interface do repositório de avaliações
/// Segue o Dependency Inversion Principle (DIP) - depende de abstração
abstract class ReviewRepository {
  /// Retorna todas as avaliações de um médico
  Future<List<ReviewModel>> getReviewsByDoctorId(String doctorId);

  /// Retorna uma avaliação pelo ID
  Future<ReviewModel?> getReviewById(String id);

  /// Adiciona uma nova avaliação
  Future<void> addReview(ReviewModel review);

  /// Calcula a média de avaliações de um médico
  Future<double> getAverageRating(String doctorId);
}

