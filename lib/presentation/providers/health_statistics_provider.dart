import 'package:flutter/material.dart';
import '../../data/models/health_statistics_model.dart';
import '../../domain/usecases/add_health_metric_usecase.dart';
import '../../domain/usecases/get_health_analysis_usecase.dart';
import '../../domain/usecases/get_health_statistics_usecase.dart';
import '../../domain/usecases/get_chart_data_usecase.dart';
import '../../domain/usecases/get_metrics_by_type_usecase.dart';
import '../../domain/usecases/get_recent_metrics_usecase.dart';
import '../../domain/usecases/get_latest_metric_usecase.dart';
import '../../domain/usecases/update_health_metric_usecase.dart';
import '../../domain/usecases/delete_health_metric_usecase.dart';
import '../../domain/usecases/get_all_metrics_usecase.dart';

/// Provider para gerenciar o estado das estatísticas de saúde
class HealthStatisticsProvider extends ChangeNotifier {
  final AddHealthMetricUseCase _addHealthMetricUseCase;
  final GetHealthStatisticsUseCase _getHealthStatisticsUseCase;
  final GetHealthAnalysisUseCase _getHealthAnalysisUseCase;
  final GetChartDataUseCase _getChartDataUseCase;
  final GetMetricsByTypeUseCase _getMetricsByTypeUseCase;
  final GetRecentMetricsUseCase _getRecentMetricsUseCase;
  final GetLatestMetricUseCase _getLatestMetricUseCase;
  final UpdateHealthMetricUseCase _updateHealthMetricUseCase;
  final DeleteHealthMetricUseCase _deleteHealthMetricUseCase;
  final GetAllMetricsUseCase _getAllMetricsUseCase;

  HealthStatisticsProvider({
    required AddHealthMetricUseCase addHealthMetricUseCase,
    required GetHealthStatisticsUseCase getHealthStatisticsUseCase,
    required GetHealthAnalysisUseCase getHealthAnalysisUseCase,
    required GetChartDataUseCase getChartDataUseCase,
    required GetMetricsByTypeUseCase getMetricsByTypeUseCase,
    required GetRecentMetricsUseCase getRecentMetricsUseCase,
    required GetLatestMetricUseCase getLatestMetricUseCase,
    required UpdateHealthMetricUseCase updateHealthMetricUseCase,
    required DeleteHealthMetricUseCase deleteHealthMetricUseCase,
    required GetAllMetricsUseCase getAllMetricsUseCase,
  }) : _addHealthMetricUseCase = addHealthMetricUseCase,
       _getHealthStatisticsUseCase = getHealthStatisticsUseCase,
       _getHealthAnalysisUseCase = getHealthAnalysisUseCase,
       _getChartDataUseCase = getChartDataUseCase,
       _getMetricsByTypeUseCase = getMetricsByTypeUseCase,
       _getRecentMetricsUseCase = getRecentMetricsUseCase,
       _getLatestMetricUseCase = getLatestMetricUseCase,
       _updateHealthMetricUseCase = updateHealthMetricUseCase,
       _deleteHealthMetricUseCase = deleteHealthMetricUseCase,
       _getAllMetricsUseCase = getAllMetricsUseCase;

  // Estados
  bool _isLoading = false;
  String? _error;
  List<HealthMetricModel> _allMetrics = [];
  final Map<HealthMetricType, List<HealthMetricModel>> _metricsByType = {};
  final Map<HealthMetricType, HealthAnalysisModel> _analyses = {};
  final Map<HealthMetricType, List<ChartDataModel>> _chartData = {};
  HealthMetricType? _selectedMetricType;
  DateTime _selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _selectedEndDate = DateTime.now();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HealthMetricModel> get allMetrics => _allMetrics;
  Map<HealthMetricType, List<HealthMetricModel>> get metricsByType => _metricsByType;
  Map<HealthMetricType, HealthAnalysisModel> get analyses => _analyses;
  Map<HealthMetricType, List<ChartDataModel>> get chartData => _chartData;
  HealthMetricType? get selectedMetricType => _selectedMetricType;
  DateTime get selectedStartDate => _selectedStartDate;
  DateTime get selectedEndDate => _selectedEndDate;

  /// Adiciona uma nova métrica de saúde
  Future<void> addMetric({
    required HealthMetricType type,
    required double value,
    required String unit,
    required DateTime date,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final metric = await _addHealthMetricUseCase.call(
        type: type,
        value: value,
        unit: unit,
        date: date,
        notes: notes,
      );

      _allMetrics.add(metric);
      _metricsByType[type] = _getMetricsByTypeUseCase.call(type);
      
      // Atualiza análises e dados de gráfico se necessário
      await _updateAnalysisAndChartData(type);
      
      notifyListeners();
    } catch (e) {
      _setError('Erro ao adicionar métrica: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza uma métrica existente
  Future<void> updateMetric(HealthMetricModel metric) async {
    try {
      _setLoading(true);
      _clearError();

      await _updateHealthMetricUseCase.call(metric);
      
      // Atualiza a lista local
      final index = _allMetrics.indexWhere((m) => m.id == metric.id);
      if (index != -1) {
        _allMetrics[index] = metric;
      }
      
      // Atualiza métricas por tipo
      _metricsByType[metric.type] = _getMetricsByTypeUseCase.call(metric.type);
      
      // Atualiza análises e dados de gráfico
      await _updateAnalysisAndChartData(metric.type);
      
      notifyListeners();
    } catch (e) {
      _setError('Erro ao atualizar métrica: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Remove uma métrica
  Future<void> deleteMetric(String metricId) async {
    try {
      _setLoading(true);
      _clearError();

      await _deleteHealthMetricUseCase.call(metricId);
      
      // Remove da lista local
      _allMetrics.removeWhere((m) => m.id == metricId);
      
      // Atualiza métricas por tipo
      for (final type in _metricsByType.keys) {
        _metricsByType[type] = _getMetricsByTypeUseCase.call(type);
      }
      
      // Atualiza análises e dados de gráfico
      for (final type in _analyses.keys) {
        await _updateAnalysisAndChartData(type);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Erro ao remover métrica: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega todas as métricas
  Future<void> loadAllMetrics() async {
    try {
      _setLoading(true);
      _clearError();

      _allMetrics = _getAllMetricsUseCase.call();
      
      // Organiza métricas por tipo
      for (final type in HealthMetricType.values) {
        _metricsByType[type] = _getMetricsByTypeUseCase.call(type);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar métricas: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega análise para um tipo de métrica
  Future<void> loadAnalysis(HealthMetricType type) async {
    try {
      _setLoading(true);
      _clearError();

      final analysis = await _getHealthAnalysisUseCase.call(
        type,
        _selectedStartDate,
        _selectedEndDate,
      );
      
      _analyses[type] = analysis;
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar análise: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega dados de gráfico para um tipo de métrica
  void loadChartData(HealthMetricType type) {
    try {
      _clearError();

      final data = _getChartDataUseCase.call(
        type,
        _selectedStartDate,
        _selectedEndDate,
      );
      
      _chartData[type] = data;
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar dados do gráfico: ${e.toString()}');
    }
  }

  /// Define o tipo de métrica selecionado
  void setSelectedMetricType(HealthMetricType? type) {
    _selectedMetricType = type;
    notifyListeners();
  }

  /// Define o período de análise
  void setDateRange(DateTime start, DateTime end) {
    _selectedStartDate = start;
    _selectedEndDate = end;
    
    // Atualiza análises e dados de gráfico para todos os tipos
    for (final type in _analyses.keys) {
      _updateAnalysisAndChartData(type);
    }
    
    notifyListeners();
  }

  /// Obtém métricas recentes de um tipo
  List<HealthMetricModel> getRecentMetrics(HealthMetricType type, int days) {
    return _getRecentMetricsUseCase.call(type, days);
  }

  /// Obtém a última métrica de um tipo
  HealthMetricModel? getLatestMetric(HealthMetricType type) {
    return _getLatestMetricUseCase.call(type);
  }

  /// Obtém métricas de um tipo específico
  List<HealthMetricModel> getMetricsByType(HealthMetricType type) {
    return _metricsByType[type] ?? [];
  }

  /// Obtém análise de um tipo específico
  HealthAnalysisModel? getAnalysis(HealthMetricType type) {
    return _analyses[type];
  }

  /// Obtém dados de gráfico de um tipo específico
  List<ChartDataModel> getChartDataForType(HealthMetricType type) {
    return _chartData[type] ?? [];
  }

  /// Obtém estatísticas de um tipo específico
  Future<HealthStatisticsModel?> getStatistics(HealthMetricType type) async {
    try {
      return await _getHealthStatisticsUseCase.call(
        type,
        _selectedStartDate,
        _selectedEndDate,
      );
    } catch (e) {
      _setError('Erro ao obter estatísticas: ${e.toString()}');
      return null;
    }
  }

  /// Atualiza análise e dados de gráfico para um tipo
  Future<void> _updateAnalysisAndChartData(HealthMetricType type) async {
    try {
      // Carrega análise
      final analysis = await _getHealthAnalysisUseCase.call(
        type,
        _selectedStartDate,
        _selectedEndDate,
      );
      _analyses[type] = analysis;
      
      // Carrega dados de gráfico
      final data = _getChartDataUseCase.call(
        type,
        _selectedStartDate,
        _selectedEndDate,
      );
      _chartData[type] = data;
    } catch (e) {
      // Ignora erros silenciosamente para não interromper outras operações
    }
  }

  /// Define estado de carregamento
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define erro
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Limpa erro
  void _clearError() {
    _error = null;
  }

  /// Limpa todos os dados
  void clear() {
    _allMetrics.clear();
    _metricsByType.clear();
    _analyses.clear();
    _chartData.clear();
    _selectedMetricType = null;
    _error = null;
    notifyListeners();
  }
}
