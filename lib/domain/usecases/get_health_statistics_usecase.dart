import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter estatísticas de saúde
class GetHealthStatisticsUseCase {
  final HealthStatisticsRepository _repository;

  GetHealthStatisticsUseCase(this._repository);

  Future<HealthStatisticsModel> call(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.getStatistics(type, start, end);
  }
}
