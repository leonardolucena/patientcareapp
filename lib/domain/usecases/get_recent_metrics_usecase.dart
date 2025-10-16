import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter métricas recentes
class GetRecentMetricsUseCase {
  final HealthStatisticsRepository _repository;

  GetRecentMetricsUseCase(this._repository);

  List<HealthMetricModel> call(HealthMetricType type, int days) {
    return _repository.getRecentMetrics(type, days);
  }
}
