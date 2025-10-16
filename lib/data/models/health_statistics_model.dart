import 'package:hive/hive.dart';

part 'health_statistics_model.g.dart';

/// Tipos de métricas de saúde
enum HealthMetricType {
  weight,           // Peso
  height,           // Altura
  bloodPressure,    // Pressão arterial
  heartRate,        // Frequência cardíaca
  temperature,      // Temperatura
  bloodSugar,       // Glicemia
  cholesterol,      // Colesterol
  bmi,             // IMC
  steps,           // Passos diários
  sleepHours,      // Horas de sono
  waterIntake,     // Ingestão de água
  mood,            // Humor
  painLevel,       // Nível de dor
  energyLevel,     // Nível de energia
  stressLevel,     // Nível de estresse
}

/// Model para métricas de saúde individuais
@HiveType(typeId: 10)
class HealthMetricModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final HealthMetricType type;

  @HiveField(2)
  final double value;

  @HiveField(3)
  final String unit; // kg, cm, mmHg, bpm, °C, mg/dL, etc.

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  const HealthMetricModel({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// Cria uma cópia do modelo com campos atualizados
  HealthMetricModel copyWith({
    String? id,
    HealthMetricType? type,
    double? value,
    String? unit,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthMetricModel(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'HealthMetricModel(id: $id, type: $type, value: $value $unit, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthMetricModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model para estatísticas agregadas de saúde
@HiveType(typeId: 11)
class HealthStatisticsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final HealthMetricType metricType;

  @HiveField(2)
  final double currentValue;

  @HiveField(3)
  final double averageValue;

  @HiveField(4)
  final double minValue;

  @HiveField(5)
  final double maxValue;

  @HiveField(6)
  final String unit;

  @HiveField(7)
  final DateTime periodStart;

  @HiveField(8)
  final DateTime periodEnd;

  @HiveField(9)
  final int totalMeasurements;

  @HiveField(10)
  final String? trend; // 'up', 'down', 'stable'

  @HiveField(11)
  final double? trendPercentage;

  @HiveField(12)
  final DateTime createdAt;

  const HealthStatisticsModel({
    required this.id,
    required this.metricType,
    required this.currentValue,
    required this.averageValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.periodStart,
    required this.periodEnd,
    required this.totalMeasurements,
    this.trend,
    this.trendPercentage,
    required this.createdAt,
  });

  /// Cria uma cópia do modelo com campos atualizados
  HealthStatisticsModel copyWith({
    String? id,
    HealthMetricType? metricType,
    double? currentValue,
    double? averageValue,
    double? minValue,
    double? maxValue,
    String? unit,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? totalMeasurements,
    String? trend,
    double? trendPercentage,
    DateTime? createdAt,
  }) {
    return HealthStatisticsModel(
      id: id ?? this.id,
      metricType: metricType ?? this.metricType,
      currentValue: currentValue ?? this.currentValue,
      averageValue: averageValue ?? this.averageValue,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      unit: unit ?? this.unit,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      totalMeasurements: totalMeasurements ?? this.totalMeasurements,
      trend: trend ?? this.trend,
      trendPercentage: trendPercentage ?? this.trendPercentage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'HealthStatisticsModel(id: $id, metricType: $metricType, currentValue: $currentValue $unit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthStatisticsModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model para dados de gráfico
class ChartDataModel {
  final DateTime date;
  final double value;
  final String? label;

  const ChartDataModel({
    required this.date,
    required this.value,
    this.label,
  });

  @override
  String toString() {
    return 'ChartDataModel(date: $date, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartDataModel && 
           other.date == date && 
           other.value == value;
  }

  @override
  int get hashCode => date.hashCode ^ value.hashCode;
}

/// Model para análise de saúde
class HealthAnalysisModel {
  final HealthMetricType metricType;
  final String title;
  final String description;
  final String status; // 'excellent', 'good', 'warning', 'critical'
  final String recommendation;
  final List<ChartDataModel> chartData;
  final HealthStatisticsModel statistics;

  const HealthAnalysisModel({
    required this.metricType,
    required this.title,
    required this.description,
    required this.status,
    required this.recommendation,
    required this.chartData,
    required this.statistics,
  });

  @override
  String toString() {
    return 'HealthAnalysisModel(metricType: $metricType, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthAnalysisModel && 
           other.metricType == metricType;
  }

  @override
  int get hashCode => metricType.hashCode;
}
