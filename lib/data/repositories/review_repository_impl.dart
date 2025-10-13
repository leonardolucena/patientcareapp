import 'package:patientcareapp/data/datasources/local_reviews_datasource.dart';
import 'package:patientcareapp/data/models/review_model.dart';
import 'package:patientcareapp/domain/repositories/review_repository.dart';

/// Implementação do repositório de avaliações
/// Segue o Dependency Inversion Principle (DIP)
class ReviewRepositoryImpl implements ReviewRepository {
  final LocalReviewsDatasource _datasource;

  ReviewRepositoryImpl(this._datasource);

  @override
  Future<List<ReviewModel>> getReviewsByDoctorId(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _datasource.getReviewsByDoctorId(doctorId);
  }

  @override
  Future<ReviewModel?> getReviewById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.getReviewById(id);
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _datasource.addReview(review);
  }

  @override
  Future<double> getAverageRating(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _datasource.getAverageRating(doctorId);
  }
}

