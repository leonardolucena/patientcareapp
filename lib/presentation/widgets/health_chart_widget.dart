import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/health_statistics_model.dart';
import '../../theme/app_colors.dart';

/// Widget para exibir gráfico de linha das métricas de saúde
class HealthLineChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;
  final String unit;
  final Color? lineColor;
  final Color? backgroundColor;

  const HealthLineChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    this.lineColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (data.isEmpty) {
      return _buildEmptyChart(context);
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _calculateInterval(),
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateBottomInterval(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length) {
                          return Text(
                            data[value.toInt()].label ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(),
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: _getMinValue() - (_getMaxValue() - _getMinValue()) * 0.1,
                maxY: _getMaxValue() + (_getMaxValue() - _getMinValue()) * 0.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        lineColor ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                        lineColor?.withOpacity(0.3) ?? (isDark ? AppColors.darkPrimary.withOpacity(0.3) : AppColors.lightPrimary.withOpacity(0.3)),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: lineColor ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                          strokeWidth: 2,
                          strokeColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          lineColor?.withOpacity(0.1) ?? (isDark ? AppColors.darkPrimary.withOpacity(0.1) : AppColors.lightPrimary.withOpacity(0.1)),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 48,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhum dado disponível',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  double _getMinValue() {
    if (data.isEmpty) return 0;
    return data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue() {
    if (data.isEmpty) return 100;
    return data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
  }

  double _calculateInterval() {
    final range = _getMaxValue() - _getMinValue();
    if (range <= 0) return 1;
    return range / 5;
  }

  double _calculateBottomInterval() {
    if (data.length <= 5) return 1;
    return data.length / 5;
  }
}

/// Widget para exibir gráfico de barras das métricas de saúde
class HealthBarChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;
  final String unit;
  final Color? barColor;
  final Color? backgroundColor;

  const HealthBarChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    this.barColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (data.isEmpty) {
      return _buildEmptyChart(context);
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxValue() + (_getMaxValue() - _getMinValue()) * 0.1,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)}$unit',
                        TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length) {
                          return Text(
                            data[value.toInt()].label ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(),
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                barGroups: data.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value,
                        color: barColor ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhum dado disponível',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  double _getMinValue() {
    if (data.isEmpty) return 0;
    return data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue() {
    if (data.isEmpty) return 100;
    return data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
  }

  double _calculateInterval() {
    final range = _getMaxValue() - _getMinValue();
    if (range <= 0) return 1;
    return range / 5;
  }
}
