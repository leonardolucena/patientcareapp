import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

/// Caso de uso para obter dados de gráfico
class GetChartDataUseCase {
  final HealthStatisticsRepository _repository;

  GetChartDataUseCase(this._repository);

  List<ChartDataModel> call(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) {
    return _repository.getChartData(type, start, end);
  }
}
