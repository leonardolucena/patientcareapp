import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter análise de saúde
class GetHealthAnalysisUseCase {
  final HealthStatisticsRepository _repository;

  GetHealthAnalysisUseCase(this._repository);

  Future<HealthAnalysisModel> call(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.getHealthAnalysis(type, start, end);
  }
}
