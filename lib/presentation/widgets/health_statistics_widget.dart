import 'package:flutter/material.dart';
import '../../data/models/health_statistics_model.dart';
import '../../theme/app_colors.dart';

/// Widget para exibir estatísticas de saúde
class HealthStatisticsCard extends StatelessWidget {
  final HealthStatisticsModel statistics;
  final VoidCallback? onTap;

  const HealthStatisticsCard({
    super.key,
    required this.statistics,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getMetricTitle(statistics.metricType),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildTrendIndicator(statistics.trend, statistics.trendPercentage),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Atual',
                      '${statistics.currentValue.toStringAsFixed(1)}${statistics.unit}',
                      isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Média',
                      '${statistics.averageValue.toStringAsFixed(1)}${statistics.unit}',
                      isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Mínimo',
                      '${statistics.minValue.toStringAsFixed(1)}${statistics.unit}',
                      isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Máximo',
                      '${statistics.maxValue.toStringAsFixed(1)}${statistics.unit}',
                      isDark ? AppColors.darkWarning : AppColors.lightWarning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${statistics.totalMeasurements} medições no período',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(String? trend, double? percentage) {
    if (trend == null || percentage == null) {
      return const SizedBox.shrink();
    }

    IconData icon;
    Color color;
    String text;

    switch (trend) {
      case 'up':
        icon = Icons.trending_up;
        color = Colors.red;
        text = '+${percentage.toStringAsFixed(1)}%';
        break;
      case 'down':
        icon = Icons.trending_down;
        color = Colors.green;
        text = '${percentage.toStringAsFixed(1)}%';
        break;
      case 'stable':
        icon = Icons.trending_flat;
        color = Colors.blue;
        text = '${percentage.toStringAsFixed(1)}%';
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
        text = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
}

/// Widget para exibir análise de saúde
class HealthAnalysisCard extends StatelessWidget {
  final HealthAnalysisModel analysis;
  final VoidCallback? onTap;

  const HealthAnalysisCard({
    super.key,
    required this.analysis,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      analysis.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildStatusIndicator(analysis.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                analysis.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(analysis.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(analysis.status).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: _getStatusColor(analysis.status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        analysis.recommendation,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    IconData icon;
    Color color;
    String text;

    switch (status) {
      case 'excellent':
        icon = Icons.check_circle;
        color = Colors.green;
        text = 'Excelente';
        break;
      case 'good':
        icon = Icons.check_circle_outline;
        color = Colors.blue;
        text = 'Bom';
        break;
      case 'warning':
        icon = Icons.warning;
        color = Colors.orange;
        text = 'Atenção';
        break;
      case 'critical':
        icon = Icons.error;
        color = Colors.red;
        text = 'Crítico';
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
        text = 'Desconhecido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// Widget para exibir métrica individual
class HealthMetricCard extends StatelessWidget {
  final HealthMetricModel metric;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HealthMetricCard({
    super.key,
    required this.metric,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 1,
      color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getMetricIcon(metric.type),
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMetricTitle(metric.type),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${metric.value.toStringAsFixed(1)}${metric.unit}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(metric.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMetricIcon(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.weight:
        return Icons.monitor_weight;
      case HealthMetricType.height:
        return Icons.height;
      case HealthMetricType.bloodPressure:
        return Icons.favorite;
      case HealthMetricType.heartRate:
        return Icons.favorite;
      case HealthMetricType.temperature:
        return Icons.thermostat;
      case HealthMetricType.bloodSugar:
        return Icons.water_drop;
      case HealthMetricType.cholesterol:
        return Icons.science;
      case HealthMetricType.bmi:
        return Icons.calculate;
      case HealthMetricType.steps:
        return Icons.directions_walk;
      case HealthMetricType.sleepHours:
        return Icons.bedtime;
      case HealthMetricType.waterIntake:
        return Icons.local_drink;
      case HealthMetricType.mood:
        return Icons.mood;
      case HealthMetricType.painLevel:
        return Icons.healing;
      case HealthMetricType.energyLevel:
        return Icons.battery_charging_full;
      case HealthMetricType.stressLevel:
        return Icons.psychology;
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
