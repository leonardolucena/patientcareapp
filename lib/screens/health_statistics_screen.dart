import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // Ordena métricas por data (mais recente primeiro)
    for (final type in groupedMetrics.keys) {
      groupedMetrics[type]!.sort((a, b) => b.date.compareTo(a.date));
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
          selectedColor: isDark ? AppColors.darkPrimary.withValues(alpha: 0.3) : AppColors.lightPrimary.withValues(alpha: 0.3),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddMetricBottomSheet(
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
      if (dateRange != null && mounted) {
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

/// BottomSheet para adicionar nova métrica
class _AddMetricBottomSheet extends StatefulWidget {
  final VoidCallback onMetricAdded;

  const _AddMetricBottomSheet({required this.onMetricAdded});

  @override
  State<_AddMetricBottomSheet> createState() => _AddMetricBottomSheetState();
}

class _AddMetricBottomSheetState extends State<_AddMetricBottomSheet> {
  HealthMetricType? _selectedType;
  final _valueController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _valueController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adicionar Métrica',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tipo de Métrica
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
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                        // Limpa todos os campos quando o tipo muda
                        _valueController.clear();
                        _heightController.clear();
                        _weightController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Campos dinâmicos baseados no tipo
                  ..._buildDynamicFields(),
                  
                  const SizedBox(height: 20),
                  
                  // Data
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
                  
                  const SizedBox(height: 20),
                  
                  // Notas
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 100), // Espaço para o botão fixo
                ],
              ),
            ),
          ),
          
          // Botão fixo na parte inferior
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid() ? _addMetric : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Adicionar Métrica',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    if (_selectedType == null) return [];
    
    switch (_selectedType!) {
      case HealthMetricType.bmi:
        return [
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              suffixText: 'kg',
              helperText: 'Ex: 70.5',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Altura (cm)',
              suffixText: 'cm',
              helperText: 'Ex: 175',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ];
      
      case HealthMetricType.bloodPressure:
        return [
          TextFormField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Pressão Sistólica (mmHg)',
              suffixText: 'mmHg',
              helperText: 'Ex: 120',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ];
      
      default:
        return [
          TextFormField(
            key: ValueKey(_selectedType),
            controller: _valueController,
            decoration: InputDecoration(
              labelText: _getMetricLabel(_selectedType),
              suffixText: _getMetricUnit(_selectedType!),
              helperText: _getMetricHelperText(_selectedType),
              border: const OutlineInputBorder(),
            ),
            keyboardType: _getKeyboardType(_selectedType),
            inputFormatters: _getInputFormatters(_selectedType),
          ),
        ];
    }
  }

  bool _isFormValid() {
    if (_selectedType == null) return false;
    
    switch (_selectedType!) {
      case HealthMetricType.bmi:
        return _weightController.text.isNotEmpty && 
               _heightController.text.isNotEmpty;
      default:
        return _valueController.text.isNotEmpty;
    }
  }

  void _addMetric() async {
    double value;
    
    // Calcula o valor baseado no tipo
    if (_selectedType == HealthMetricType.bmi) {
      final weight = double.tryParse(_weightController.text);
      final height = double.tryParse(_heightController.text);
      
      if (weight == null || height == null) {
        _showError('Por favor, insira valores válidos para peso e altura');
        return;
      }
      
      // IMC = peso (kg) / (altura (m))²
      value = weight / ((height / 100) * (height / 100));
    } else {
      value = double.tryParse(_valueController.text) ?? 0;
      if (value == 0) {
        _showError('Por favor, insira um valor válido');
        return;
      }
    }

    // Validações específicas por tipo
    if (!_validateMetricValue(_selectedType!, value)) {
      return;
    }

    try {
      await context.read<HealthStatisticsProvider>().addMetric(
        type: _selectedType!,
        value: value,
        unit: _getMetricUnit(_selectedType!),
        date: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Métrica de ${_getMetricTitle(_selectedType!)} adicionada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onMetricAdded();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar métrica: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _validateMetricValue(HealthMetricType type, double value) {
    switch (type) {
      case HealthMetricType.weight:
        if (value <= 0 || value > 300) {
          _showValidationError('Peso deve estar entre 1 e 300 kg');
          return false;
        }
        break;
      case HealthMetricType.height:
        if (value <= 0 || value > 250) {
          _showValidationError('Altura deve estar entre 1 e 250 cm');
          return false;
        }
        break;
      case HealthMetricType.bloodPressure:
        if (value <= 0 || value > 300) {
          _showValidationError('Pressão arterial deve estar entre 1 e 300 mmHg');
          return false;
        }
        break;
      case HealthMetricType.heartRate:
        if (value <= 0 || value > 250) {
          _showValidationError('Frequência cardíaca deve estar entre 1 e 250 bpm');
          return false;
        }
        break;
      case HealthMetricType.temperature:
        if (value < 30 || value > 50) {
          _showValidationError('Temperatura deve estar entre 30 e 50°C');
          return false;
        }
        break;
      case HealthMetricType.mood:
      case HealthMetricType.painLevel:
      case HealthMetricType.energyLevel:
      case HealthMetricType.stressLevel:
        if (value < 1 || value > 10) {
          _showValidationError('Valor deve estar entre 1 e 10');
          return false;
        }
        break;
      case HealthMetricType.steps:
        if (value < 0 || value > 100000) {
          _showValidationError('Número de passos deve estar entre 0 e 100.000');
          return false;
        }
        break;
      case HealthMetricType.sleepHours:
        if (value < 0 || value > 24) {
          _showValidationError('Horas de sono devem estar entre 0 e 24');
          return false;
        }
        break;
      case HealthMetricType.waterIntake:
        if (value < 0 || value > 20) {
          _showValidationError('Ingestão de água deve estar entre 0 e 20 litros');
          return false;
        }
        break;
      default:
        if (value <= 0) {
          _showValidationError('Valor deve ser maior que zero');
          return false;
        }
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
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

  String _getMetricLabel(HealthMetricType? type) {
    if (type == null) return 'Valor';
    
    switch (type) {
      case HealthMetricType.weight:
        return 'Peso (kg)';
      case HealthMetricType.height:
        return 'Altura (cm)';
      case HealthMetricType.bloodPressure:
        return 'Pressão Sistólica (mmHg)';
      case HealthMetricType.heartRate:
        return 'Frequência Cardíaca (bpm)';
      case HealthMetricType.temperature:
        return 'Temperatura (°C)';
      case HealthMetricType.bloodSugar:
        return 'Glicemia (mg/dL)';
      case HealthMetricType.cholesterol:
        return 'Colesterol Total (mg/dL)';
      case HealthMetricType.bmi:
        return 'IMC (kg/m²)';
      case HealthMetricType.steps:
        return 'Número de Passos';
      case HealthMetricType.sleepHours:
        return 'Horas de Sono';
      case HealthMetricType.waterIntake:
        return 'Ingestão de Água (L)';
      case HealthMetricType.mood:
        return 'Nível de Humor (1-10)';
      case HealthMetricType.painLevel:
        return 'Nível de Dor (1-10)';
      case HealthMetricType.energyLevel:
        return 'Nível de Energia (1-10)';
      case HealthMetricType.stressLevel:
        return 'Nível de Estresse (1-10)';
    }
  }

  String? _getMetricHelperText(HealthMetricType? type) {
    if (type == null) return null;
    
    switch (type) {
      case HealthMetricType.weight:
        return 'Ex: 70.5';
      case HealthMetricType.height:
        return 'Ex: 175';
      case HealthMetricType.bloodPressure:
        return 'Ex: 120 (apenas sistólica)';
      case HealthMetricType.heartRate:
        return 'Ex: 72';
      case HealthMetricType.temperature:
        return 'Ex: 36.5';
      case HealthMetricType.bloodSugar:
        return 'Ex: 95';
      case HealthMetricType.cholesterol:
        return 'Ex: 180';
      case HealthMetricType.bmi:
        return 'Ex: 22.5';
      case HealthMetricType.steps:
        return 'Ex: 8500';
      case HealthMetricType.sleepHours:
        return 'Ex: 7.5';
      case HealthMetricType.waterIntake:
        return 'Ex: 2.5';
      case HealthMetricType.mood:
        return '1 = muito triste, 10 = muito feliz';
      case HealthMetricType.painLevel:
        return '1 = sem dor, 10 = dor extrema';
      case HealthMetricType.energyLevel:
        return '1 = sem energia, 10 = muita energia';
      case HealthMetricType.stressLevel:
        return '1 = sem estresse, 10 = muito estressado';
    }
  }

  TextInputType _getKeyboardType(HealthMetricType? type) {
    if (type == null) return TextInputType.number;
    
    switch (type) {
      case HealthMetricType.mood:
      case HealthMetricType.painLevel:
      case HealthMetricType.energyLevel:
      case HealthMetricType.stressLevel:
        return TextInputType.number;
      default:
        return TextInputType.numberWithOptions(decimal: true);
    }
  }

  List<TextInputFormatter>? _getInputFormatters(HealthMetricType? type) {
    if (type == null) return null;
    
    switch (type) {
      case HealthMetricType.mood:
      case HealthMetricType.painLevel:
      case HealthMetricType.energyLevel:
      case HealthMetricType.stressLevel:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^[1-9]$|^10$')),
        ];
      case HealthMetricType.height:
      case HealthMetricType.steps:
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
      default:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ];
    }
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
