import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para atualizar métrica
class UpdateHealthMetricUseCase {
  final HealthStatisticsRepository _repository;

  UpdateHealthMetricUseCase(this._repository);

  Future<void> call(HealthMetricModel metric) async {
    await _repository.updateMetric(metric);
  }
}
