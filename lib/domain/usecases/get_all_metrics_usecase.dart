import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter todas as métricas
class GetAllMetricsUseCase {
  final HealthStatisticsRepository _repository;

  GetAllMetricsUseCase(this._repository);

  List<HealthMetricModel> call() {
    return _repository.getAllMetrics();
  }
}
