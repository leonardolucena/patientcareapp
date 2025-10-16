import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para adicionar uma nova métrica de saúde
class AddHealthMetricUseCase {
  final HealthStatisticsRepository _repository;

  AddHealthMetricUseCase(this._repository);

  Future<HealthMetricModel> call({
    required HealthMetricType type,
    required double value,
    required String unit,
    required DateTime date,
    String? notes,
  }) async {
    return await _repository.addMetric(
      type: type,
      value: value,
      unit: unit,
      date: date,
      notes: notes,
    );
  }
}
