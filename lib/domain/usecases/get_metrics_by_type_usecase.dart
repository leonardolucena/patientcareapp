import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter métricas por tipo
class GetMetricsByTypeUseCase {
  final HealthStatisticsRepository _repository;

  GetMetricsByTypeUseCase(this._repository);

  List<HealthMetricModel> call(HealthMetricType type) {
    return _repository.getMetricsByType(type);
  }
}
