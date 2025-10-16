import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/health_statistics_model.dart';
import '../../presentation/providers/health_statistics_provider.dart';
import '../../presentation/widgets/health_chart_widget.dart';
import '../../presentation/widgets/health_statistics_widget.dart';
import '../../theme/app_colors.dart';

class HealthStatisticsScreen extends StatefulWidget {
  const HealthStatisticsScreen({super.key});

  @override
  State<HealthStatisticsScreen> createState() => _HealthStatisticsScreenState();
}

class _HealthStatisticsScreenState extends State<HealthStatisticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  HealthMetricType? _selectedMetricType;
  DateTime _selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthStatisticsProvider>().loadAllMetrics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Estatísticas de Saúde'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMetricDialog,
            tooltip: 'Adicionar Métrica',
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangeDialog,
            tooltip: 'Filtrar Período',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Visão Geral', icon: Icon(Icons.dashboard)),
            Tab(text: 'Gráficos', icon: Icon(Icons.show_chart)),
            Tab(text: 'Análises', icon: Icon(Icons.analytics)),
          ],
          labelColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          indicatorColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      ),
      body: Consumer<HealthStatisticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: isDark ? AppColors.darkError : AppColors.lightError,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar dados',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAllMetrics(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(provider),
              _buildChartsTab(provider),
              _buildAnalysisTab(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(HealthStatisticsProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => provider.loadAllMetrics(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo das métricas
            Text(
              'Resumo das Métricas',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricsSummary(provider),
            const SizedBox(height: 24),
            
            // Métricas recentes
            Text(
              'Métricas Recentes',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentMetrics(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsTab(HealthStatisticsProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seletor de métrica
          Text(
            'Selecione uma Métrica',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricTypeSelector(provider),
          const SizedBox(height: 24),
          
          // Gráficos
          if (_selectedMetricType != null) ...[
            Text(
              'Gráfico de Linha',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            HealthLineChartWidget(
              data: provider.getChartDataForType(_selectedMetricType!),
              title: _getMetricTitle(_selectedMetricType!),
              unit: _getMetricUnit(_selectedMetricType!),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Gráfico de Barras',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            HealthBarChartWidget(
              data: provider.getChartDataForType(_selectedMetricType!),
              title: _getMetricTitle(_selectedMetricType!),
              unit: _getMetricUnit(_selectedMetricType!),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 64,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selecione uma métrica para visualizar os gráficos',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisTab(HealthStatisticsProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        for (final type in HealthMetricType.values) {
          await provider.loadAnalysis(type);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Análises de Saúde',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthAnalyses(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSummary(HealthStatisticsProvider provider) {
    final metrics = provider.allMetrics;
    if (metrics.isEmpty) {
      return _buildEmptyState('Nenhuma métrica registrada');
    }

    // Agrupa métricas por tipo
    final Map<HealthMetricType, List<HealthMetricModel>> groupedMetrics = {};
    for (final metric in metrics) {
      groupedMetrics.putIfAbsent(metric.type, () => []).add(metric);
    }

    return Column(
      children: groupedMetrics.entries.map((entry) {
        final type = entry.key;
        final typeMetrics = entry.value;
        final latestMetric = typeMetrics.first; // Já ordenado por data desc
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: HealthMetricCard(
            metric: latestMetric,
            onTap: () {
              setState(() {
                _selectedMetricType = type;
                _tabController.animateTo(1); // Vai para aba de gráficos
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentMetrics(HealthStatisticsProvider provider) {
    final recentMetrics = provider.allMetrics.take(10).toList();
    
    if (recentMetrics.isEmpty) {
      return _buildEmptyState('Nenhuma métrica recente');
    }

    return Column(
      children: recentMetrics.map((metric) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: HealthMetricCard(
            metric: metric,
            onEdit: () => _showEditMetricDialog(metric),
            onDelete: () => _showDeleteMetricDialog(metric),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricTypeSelector(HealthStatisticsProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final availableTypes = provider.metricsByType.keys.toList();
    
    if (availableTypes.isEmpty) {
      return _buildEmptyState('Nenhuma métrica disponível para gráficos');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableTypes.map((type) {
        final isSelected = _selectedMetricType == type;
        return FilterChip(
          label: Text(_getMetricTitle(type)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedMetricType = selected ? type : null;
            });
            if (selected) {
              provider.loadChartData(type);
            }
          },
          selectedColor: isDark ? AppColors.darkPrimary.withOpacity(0.3) : AppColors.lightPrimary.withOpacity(0.3),
          checkmarkColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        );
      }).toList(),
    );
  }

  Widget _buildHealthAnalyses(HealthStatisticsProvider provider) {
    final analyses = provider.analyses.values.toList();
    
    if (analyses.isEmpty) {
      return _buildEmptyState('Nenhuma análise disponível');
    }

    return Column(
      children: analyses.map((analysis) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HealthAnalysisCard(
            analysis: analysis,
            onTap: () {
              setState(() {
                _selectedMetricType = analysis.metricType;
                _tabController.animateTo(1); // Vai para aba de gráficos
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMetricDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddMetricDialog(
        onMetricAdded: () {
          context.read<HealthStatisticsProvider>().loadAllMetrics();
        },
      ),
    );
  }

  void _showEditMetricDialog(HealthMetricModel metric) {
    showDialog(
      context: context,
      builder: (context) => _EditMetricDialog(
        metric: metric,
        onMetricUpdated: () {
          context.read<HealthStatisticsProvider>().loadAllMetrics();
        },
      ),
    );
  }

  void _showDeleteMetricDialog(HealthMetricModel metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir esta métrica de ${_getMetricTitle(metric.type)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<HealthStatisticsProvider>().deleteMetric(metric.id);
              Navigator.of(context).pop();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDateRangeDialog() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _selectedStartDate,
        end: _selectedEndDate,
      ),
    ).then((dateRange) {
      if (dateRange != null) {
        setState(() {
          _selectedStartDate = dateRange.start;
          _selectedEndDate = dateRange.end;
        });
        context.read<HealthStatisticsProvider>().setDateRange(
          _selectedStartDate,
          _selectedEndDate,
        );
      }
    });
  }

  String _getMetricTitle(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.weight:
        return 'Peso';
      case HealthMetricType.height:
        return 'Altura';
      case HealthMetricType.bloodPressure:
        return 'Pressão Arterial';
      case HealthMetricType.heartRate:
        return 'Frequência Cardíaca';
      case HealthMetricType.temperature:
        return 'Temperatura';
      case HealthMetricType.bloodSugar:
        return 'Glicemia';
      case HealthMetricType.cholesterol:
        return 'Colesterol';
      case HealthMetricType.bmi:
        return 'IMC';
      case HealthMetricType.steps:
        return 'Passos';
      case HealthMetricType.sleepHours:
        return 'Horas de Sono';
      case HealthMetricType.waterIntake:
        return 'Ingestão de Água';
      case HealthMetricType.mood:
        return 'Humor';
      case HealthMetricType.painLevel:
        return 'Nível de Dor';
      case HealthMetricType.energyLevel:
        return 'Nível de Energia';
      case HealthMetricType.stressLevel:
        return 'Nível de Estresse';
    }
  }

  String _getMetricUnit(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.weight:
        return 'kg';
      case HealthMetricType.height:
        return 'cm';
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.temperature:
        return '°C';
      case HealthMetricType.bloodSugar:
        return 'mg/dL';
      case HealthMetricType.cholesterol:
        return 'mg/dL';
      case HealthMetricType.bmi:
        return 'kg/m²';
      case HealthMetricType.steps:
        return 'passos';
      case HealthMetricType.sleepHours:
        return 'h';
      case HealthMetricType.waterIntake:
        return 'L';
      case HealthMetricType.mood:
        return '/10';
      case HealthMetricType.painLevel:
        return '/10';
      case HealthMetricType.energyLevel:
        return '/10';
      case HealthMetricType.stressLevel:
        return '/10';
    }
  }
}

/// Dialog para adicionar nova métrica
class _AddMetricDialog extends StatefulWidget {
  final VoidCallback onMetricAdded;

  const _AddMetricDialog({required this.onMetricAdded});

  @override
  State<_AddMetricDialog> createState() => _AddMetricDialogState();
}

class _AddMetricDialogState extends State<_AddMetricDialog> {
  HealthMetricType? _selectedType;
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Métrica'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<HealthMetricType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Métrica',
                border: OutlineInputBorder(),
              ),
              items: HealthMetricType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getMetricTitle(type)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor',
                suffixText: _selectedType != null ? _getMetricUnit(_selectedType!) : null,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                ),
                child: Text(_formatDate(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _selectedType != null && _valueController.text.isNotEmpty
              ? _addMetric
              : null,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  void _addMetric() {
    final value = double.tryParse(_valueController.text);
    if (value == null) return;

    context.read<HealthStatisticsProvider>().addMetric(
      type: _selectedType!,
      value: value,
      unit: _getMetricUnit(_selectedType!),
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    widget.onMetricAdded();
    Navigator.of(context).pop();
  }

  String _getMetricTitle(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.weight:
        return 'Peso';
      case HealthMetricType.height:
        return 'Altura';
      case HealthMetricType.bloodPressure:
        return 'Pressão Arterial';
      case HealthMetricType.heartRate:
        return 'Frequência Cardíaca';
      case HealthMetricType.temperature:
        return 'Temperatura';
      case HealthMetricType.bloodSugar:
        return 'Glicemia';
      case HealthMetricType.cholesterol:
        return 'Colesterol';
      case HealthMetricType.bmi:
        return 'IMC';
      case HealthMetricType.steps:
        return 'Passos';
      case HealthMetricType.sleepHours:
        return 'Horas de Sono';
      case HealthMetricType.waterIntake:
        return 'Ingestão de Água';
      case HealthMetricType.mood:
        return 'Humor';
      case HealthMetricType.painLevel:
        return 'Nível de Dor';
      case HealthMetricType.energyLevel:
        return 'Nível de Energia';
      case HealthMetricType.stressLevel:
        return 'Nível de Estresse';
    }
  }

  String _getMetricUnit(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.weight:
        return 'kg';
      case HealthMetricType.height:
        return 'cm';
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.temperature:
        return '°C';
      case HealthMetricType.bloodSugar:
        return 'mg/dL';
      case HealthMetricType.cholesterol:
        return 'mg/dL';
      case HealthMetricType.bmi:
        return 'kg/m²';
      case HealthMetricType.steps:
        return 'passos';
      case HealthMetricType.sleepHours:
        return 'h';
      case HealthMetricType.waterIntake:
        return 'L';
      case HealthMetricType.mood:
        return '/10';
      case HealthMetricType.painLevel:
        return '/10';
      case HealthMetricType.energyLevel:
        return '/10';
      case HealthMetricType.stressLevel:
        return '/10';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Dialog para editar métrica existente
class _EditMetricDialog extends StatefulWidget {
  final HealthMetricModel metric;
  final VoidCallback onMetricUpdated;

  const _EditMetricDialog({
    required this.metric,
    required this.onMetricUpdated,
  });

  @override
  State<_EditMetricDialog> createState() => _EditMetricDialogState();
}

class _EditMetricDialogState extends State<_EditMetricDialog> {
  late final TextEditingController _valueController;
  late final TextEditingController _notesController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(text: widget.metric.value.toString());
    _notesController = TextEditingController(text: widget.metric.notes ?? '');
    _selectedDate = widget.metric.date;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Métrica'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor',
                suffixText: widget.metric.unit,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                ),
                child: Text(_formatDate(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _valueController.text.isNotEmpty ? _updateMetric : null,
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  void _updateMetric() {
    final value = double.tryParse(_valueController.text);
    if (value == null) return;

    final updatedMetric = widget.metric.copyWith(
      value: value,
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    context.read<HealthStatisticsProvider>().updateMetric(updatedMetric);
    widget.onMetricUpdated();
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
