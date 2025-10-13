import 'package:patientcareapp/data/models/review_model.dart';

/// Datasource local com dados fictícios de avaliações
class LocalReviewsDatasource {
  static final List<ReviewModel> _reviews = [
    // Reviews para Dr. Carlos Silva (doc_001)
    const ReviewModel(
      id: 'rev_001',
      doctorId: 'doc_001',
      userName: 'Maria Silva',
      date: '15 dias atrás',
      rating: 5.0,
      comment: 'Excelente profissional! Muito atencioso e dedicado. Recomendo fortemente.',
      avatar: '👩',
    ),
    const ReviewModel(
      id: 'rev_002',
      doctorId: 'doc_001',
      userName: 'João Santos',
      date: '1 mês atrás',
      rating: 4.5,
      comment: 'Ótimo médico, explicou tudo detalhadamente. Consulta muito proveitosa.',
      avatar: '👨',
    ),
    const ReviewModel(
      id: 'rev_003',
      doctorId: 'doc_001',
      userName: 'Ana Paula',
      date: '2 meses atrás',
      rating: 5.0,
      comment: 'Profissional extremamente competente e empático. Melhor médico que já consultei!',
      avatar: '👩',
    ),
    const ReviewModel(
      id: 'rev_004',
      doctorId: 'doc_001',
      userName: 'Pedro Oliveira',
      date: '2 meses atrás',
      rating: 4.0,
      comment: 'Muito bom atendimento, porém a espera foi um pouco longa.',
      avatar: '👨',
    ),
    const ReviewModel(
      id: 'rev_005',
      doctorId: 'doc_001',
      userName: 'Carla Mendes',
      date: '3 meses atrás',
      rating: 5.0,
      comment: 'Adorei! Médico super qualificado e consultório muito bem equipado.',
      avatar: '👩',
    ),
  ];

  List<ReviewModel> getReviewsByDoctorId(String doctorId) {
    return _reviews.where((review) => review.doctorId == doctorId).toList();
  }

  ReviewModel? getReviewById(String id) {
    try {
      return _reviews.firstWhere((review) => review.id == id);
    } catch (e) {
      return null;
    }
  }

  void addReview(ReviewModel review) {
    _reviews.add(review);
  }

  double getAverageRating(String doctorId) {
    final doctorReviews = getReviewsByDoctorId(doctorId);
    if (doctorReviews.isEmpty) return 0.0;
    
    final sum = doctorReviews.fold<double>(
      0.0,
      (prev, review) => prev + review.rating,
    );
    return sum / doctorReviews.length;
  }
}

