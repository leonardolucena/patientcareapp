import 'package:patientcareapp/data/models/review_model.dart';
import 'package:patientcareapp/domain/repositories/review_repository.dart';

/// Use Case para obter avaliações de um médico
/// Segue o Single Responsibility Principle (SRP)
class GetDoctorReviewsUseCase {
  final ReviewRepository _repository;

  GetDoctorReviewsUseCase(this._repository);

  Future<List<ReviewModel>> call(String doctorId) async {
    return await _repository.getReviewsByDoctorId(doctorId);
  }
}

