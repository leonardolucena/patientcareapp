import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/health_statistics_model.dart';
import '../../domain/repositories/health_statistics_repository.dart';

class HealthStatisticsRepositoryImpl implements HealthStatisticsRepository {
  static const String _metricsBoxName = 'health_metrics';
  
  late Box<HealthMetricModel> _metricsBox;
  final Uuid _uuid = const Uuid();

  Future<void> initialize() async {
    _metricsBox = await Hive.openBox<HealthMetricModel>(_metricsBoxName);
  }

  @override
  Future<HealthMetricModel> addMetric({
    required HealthMetricType type,
    required double value,
    required String unit,
    required DateTime date,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    
    final metric = HealthMetricModel(
      id: id,
      type: type,
      value: value,
      unit: unit,
      date: date,
      notes: notes,
      createdAt: now,
    );

    await _metricsBox.put(id, metric);
    return metric;
  }

  @override
  List<HealthMetricModel> getMetricsByType(HealthMetricType type) {
    return _metricsBox.values
        .where((metric) => metric.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<HealthMetricModel> getMetricsByPeriod(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) {
    return _metricsBox.values
        .where((metric) => 
          metric.type == type &&
          metric.date.isAfter(start.subtract(const Duration(days: 1))) &&
          metric.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  HealthMetricModel? getLatestMetric(HealthMetricType type) {
    final metrics = getMetricsByType(type);
    return metrics.isNotEmpty ? metrics.first : null;
  }

  @override
  Future<void> updateMetric(HealthMetricModel metric) async {
    final updatedMetric = metric.copyWith(updatedAt: DateTime.now());
    await _metricsBox.put(metric.id, updatedMetric);
  }

  @override
  Future<void> deleteMetric(String metricId) async {
    await _metricsBox.delete(metricId);
  }

  @override
  Future<HealthStatisticsModel> getStatistics(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) async {
    final metrics = getMetricsByPeriod(type, start, end);
    
    if (metrics.isEmpty) {
      throw Exception('Nenhuma métrica encontrada para o período especificado');
    }

    final values = metrics.map((m) => m.value).toList();
    final currentValue = values.last;
    final averageValue = values.reduce((a, b) => a + b) / values.length;
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final unit = metrics.first.unit;
    final trend = calculateTrend(metrics);
    final trendPercentage = calculateTrendPercentage(metrics);

    final statistics = HealthStatisticsModel(
      id: _uuid.v4(),
      metricType: type,
      currentValue: currentValue,
      averageValue: averageValue,
      minValue: minValue,
      maxValue: maxValue,
      unit: unit,
      periodStart: start,
      periodEnd: end,
      totalMeasurements: metrics.length,
      trend: trend,
      trendPercentage: trendPercentage,
      createdAt: DateTime.now(),
    );

    return statistics;
  }

  @override
  List<ChartDataModel> getChartData(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) {
    final metrics = getMetricsByPeriod(type, start, end);
    
    return metrics.map((metric) => ChartDataModel(
      date: metric.date,
      value: metric.value,
      label: _formatDateLabel(metric.date),
    )).toList();
  }

  @override
  Future<HealthAnalysisModel> getHealthAnalysis(
    HealthMetricType type,
    DateTime start,
    DateTime end,
  ) async {
    final statistics = await getStatistics(type, start, end);
    final chartData = getChartData(type, start, end);
    
    final analysis = _generateHealthAnalysis(type, statistics, chartData);
    return analysis;
  }

  @override
  List<HealthMetricModel> getAllMetrics() {
    return _metricsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<HealthMetricModel> getRecentMetrics(HealthMetricType type, int days) {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    return getMetricsByPeriod(type, startDate, endDate);
  }

  @override
  String? calculateTrend(List<HealthMetricModel> metrics) {
    if (metrics.length < 2) return null;
    
    final firstHalf = metrics.take(metrics.length ~/ 2).map((m) => m.value).toList();
    final secondHalf = metrics.skip(metrics.length ~/ 2).map((m) => m.value).toList();
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    final difference = secondAvg - firstAvg;
    final percentageChange = (difference / firstAvg) * 100;
    
    if (percentageChange > 5) return 'up';
    if (percentageChange < -5) return 'down';
    return 'stable';
  }

  @override
  double? calculateTrendPercentage(List<HealthMetricModel> metrics) {
    if (metrics.length < 2) return null;
    
    final firstHalf = metrics.take(metrics.length ~/ 2).map((m) => m.value).toList();
    final secondHalf = metrics.skip(metrics.length ~/ 2).map((m) => m.value).toList();
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    return ((secondAvg - firstAvg) / firstAvg) * 100;
  }

  /// Formata a data para exibição no gráfico
  String _formatDateLabel(DateTime date) {
    return '${date.day}/${date.month}';
  }

  /// Gera análise de saúde baseada nas estatísticas
  HealthAnalysisModel _generateHealthAnalysis(
    HealthMetricType type,
    HealthStatisticsModel statistics,
    List<ChartDataModel> chartData,
  ) {
    String title;
    String description;
    String status;
    String recommendation;

    switch (type) {
      case HealthMetricType.weight:
        title = 'Análise de Peso';
        description = 'Monitoramento do peso corporal';
        status = _getWeightStatus(statistics.currentValue);
        recommendation = _getWeightRecommendation(statistics);
        break;
      case HealthMetricType.bloodPressure:
        title = 'Análise de Pressão Arterial';
        description = 'Monitoramento da pressão arterial';
        status = _getBloodPressureStatus(statistics.currentValue);
        recommendation = _getBloodPressureRecommendation(statistics);
        break;
      case HealthMetricType.heartRate:
        title = 'Análise de Frequência Cardíaca';
        description = 'Monitoramento da frequência cardíaca';
        status = _getHeartRateStatus(statistics.currentValue);
        recommendation = _getHeartRateRecommendation(statistics);
        break;
      case HealthMetricType.temperature:
        title = 'Análise de Temperatura';
        description = 'Monitoramento da temperatura corporal';
        status = _getTemperatureStatus(statistics.currentValue);
        recommendation = _getTemperatureRecommendation(statistics);
        break;
      case HealthMetricType.bmi:
        title = 'Análise de IMC';
        description = 'Monitoramento do Índice de Massa Corporal';
        status = _getBMIStatus(statistics.currentValue);
        recommendation = _getBMIRecommendation(statistics);
        break;
      default:
        title = 'Análise de ${type.name}';
        description = 'Monitoramento de métrica de saúde';
        status = 'good';
        recommendation = 'Continue monitorando regularmente.';
    }

    return HealthAnalysisModel(
      metricType: type,
      title: title,
      description: description,
      status: status,
      recommendation: recommendation,
      chartData: chartData,
      statistics: statistics,
    );
  }

  String _getWeightStatus(double weight) {
    // Valores de referência para peso (kg) - ajustar conforme necessário
    if (weight < 50) return 'warning';
    if (weight > 120) return 'warning';
    return 'good';
  }

  String _getBloodPressureStatus(double pressure) {
    // Valores de referência para pressão arterial (mmHg)
    if (pressure < 90) return 'warning';
    if (pressure > 140) return 'critical';
    return 'good';
  }

  String _getHeartRateStatus(double heartRate) {
    // Valores de referência para frequência cardíaca (bpm)
    if (heartRate < 60) return 'warning';
    if (heartRate > 100) return 'warning';
    return 'good';
  }

  String _getTemperatureStatus(double temperature) {
    // Valores de referência para temperatura (°C)
    if (temperature < 36.0) return 'warning';
    if (temperature > 37.5) return 'critical';
    return 'good';
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'warning';
    if (bmi > 25) return 'warning';
    return 'good';
  }

  String _getWeightRecommendation(HealthStatisticsModel statistics) {
    if (statistics.trend == 'up') {
      return 'Seu peso está aumentando. Considere ajustar a dieta e aumentar a atividade física.';
    } else if (statistics.trend == 'down') {
      return 'Seu peso está diminuindo. Certifique-se de manter uma alimentação equilibrada.';
    }
    return 'Seu peso está estável. Continue mantendo hábitos saudáveis.';
  }

  String _getBloodPressureRecommendation(HealthStatisticsModel statistics) {
    if (statistics.currentValue > 140) {
      return 'Sua pressão arterial está alta. Consulte um médico e considere reduzir o sal na dieta.';
    } else if (statistics.currentValue < 90) {
      return 'Sua pressão arterial está baixa. Mantenha-se hidratado e consulte um médico se necessário.';
    }
    return 'Sua pressão arterial está dentro dos valores normais. Continue monitorando.';
  }

  String _getHeartRateRecommendation(HealthStatisticsModel statistics) {
    if (statistics.currentValue > 100) {
      return 'Sua frequência cardíaca está elevada. Considere reduzir o estresse e praticar exercícios de relaxamento.';
    } else if (statistics.currentValue < 60) {
      return 'Sua frequência cardíaca está baixa. Se você não é atleta, consulte um médico.';
    }
    return 'Sua frequência cardíaca está normal. Continue praticando exercícios regularmente.';
  }

  String _getTemperatureRecommendation(HealthStatisticsModel statistics) {
    if (statistics.currentValue > 37.5) {
      return 'Sua temperatura está elevada. Pode indicar febre. Descanse e consulte um médico se persistir.';
    } else if (statistics.currentValue < 36.0) {
      return 'Sua temperatura está baixa. Certifique-se de estar aquecido e consulte um médico se necessário.';
    }
    return 'Sua temperatura está normal. Continue monitorando sua saúde.';
  }

  String _getBMIRecommendation(HealthStatisticsModel statistics) {
    if (statistics.currentValue < 18.5) {
      return 'Seu IMC indica baixo peso. Consulte um nutricionista para uma dieta adequada.';
    } else if (statistics.currentValue > 25) {
      return 'Seu IMC indica sobrepeso. Considere ajustar a dieta e aumentar a atividade física.';
    }
    return 'Seu IMC está dentro da faixa normal. Continue mantendo hábitos saudáveis.';
  }
}
