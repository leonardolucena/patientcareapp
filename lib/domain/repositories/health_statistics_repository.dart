import '../../data/models/health_statistics_model.dart';

abstract class HealthStatisticsRepository {
  /// Adiciona uma nova métrica de saúde
  Future<HealthMetricModel> addMetric({
    required HealthMetricType type,
    required double value,
    required String unit,
    required DateTime date,
    String? notes,
  });

  /// Obtém todas as métricas de um tipo específico
  List<HealthMetricModel> getMetricsByType(HealthMetricType type);

  /// Obtém métricas de um período específico
  List<HealthMetricModel> getMetricsByPeriod(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  );

  /// Obtém a última métrica registrada de um tipo
  HealthMetricModel? getLatestMetric(HealthMetricType type);

  /// Atualiza uma métrica existente
  Future<void> updateMetric(HealthMetricModel metric);

  /// Remove uma métrica
  Future<void> deleteMetric(String metricId);

  /// Obtém estatísticas agregadas para um tipo de métrica
  Future<HealthStatisticsModel> getStatistics(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  );

  /// Obtém dados para gráfico de um tipo de métrica
  List<ChartDataModel> getChartData(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  );

  /// Obtém análise completa de saúde para um tipo de métrica
  Future<HealthAnalysisModel> getHealthAnalysis(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  );

  /// Obtém todas as métricas disponíveis
  List<HealthMetricModel> getAllMetrics();

  /// Obtém métricas dos últimos N dias
  List<HealthMetricModel> getRecentMetrics(HealthMetricType type, int days);

  /// Calcula tendência de uma métrica
  String? calculateTrend(List<HealthMetricModel> metrics);

  /// Calcula percentual de mudança da tendência
  double? calculateTrendPercentage(List<HealthMetricModel> metrics);
}
