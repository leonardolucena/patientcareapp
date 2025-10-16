import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter última métrica
class GetLatestMetricUseCase {
  final HealthStatisticsRepository _repository;

  GetLatestMetricUseCase(this._repository);

  HealthMetricModel? call(HealthMetricType type) {
    return _repository.getLatestMetric(type);
  }
}
