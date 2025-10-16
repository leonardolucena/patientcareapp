import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para deletar métrica
class DeleteHealthMetricUseCase {
  final HealthStatisticsRepository _repository;

  DeleteHealthMetricUseCase(this._repository);

  Future<void> call(String metricId) async {
    await _repository.deleteMetric(metricId);
  }
}
