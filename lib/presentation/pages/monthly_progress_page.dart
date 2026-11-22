import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/monthly_progress_stats.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../widgets/page_app_bar.dart';

class MonthlyProgressPage extends StatefulWidget {
  const MonthlyProgressPage({super.key});

  @override
  State<MonthlyProgressPage> createState() => _MonthlyProgressPageState();
}

class _MonthlyProgressPageState extends State<MonthlyProgressPage> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
  }

  double _maxY(List<DayActivity> days) {
    var peak = 0;
    for (final d in days) {
      if (d.added > peak) peak = d.added;
      if (d.completed > peak) peak = d.completed;
    }
    if (peak == 0) return 4;
    return (peak + 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : AppColors.textMuted;
    final gridColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.divider;

    return Scaffold(
      appBar: const PageAppBar(title: 'Monthly progress'),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          final days = buildMonthlyDayActivity(state.todos, _month);
          final totalAdded = monthlyTotalAdded(days);
          final totalCompleted = monthlyTotalCompleted(days);
          final maxY = _maxY(days);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: () => _shiftMonth(-1),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.yMMMM().format(_month),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next month',
                    onPressed: () => _shiftMonth(1),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tasks added vs completed each day',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(
                    color: AppColors.accentGreen.withValues(alpha: 0.85),
                    label: 'Added',
                  ),
                  const SizedBox(width: 20),
                  _LegendDot(
                    color: AppColors.seedGreen,
                    label: 'Completed',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 260,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY <= 4 ? 1 : (maxY / 4).ceilToDouble(),
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: gridColor,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: days.length > 20 ? 5 : 2,
                              getTitlesWidget: (value, meta) {
                                final day = value.toInt();
                                if (day < 1 || day > days.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    '$day',
                                    style: TextStyle(fontSize: 10, color: muted),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          for (final day in days)
                            BarChartGroupData(
                              x: day.day,
                              barsSpace: 4,
                              barRods: [
                                BarChartRodData(
                                  toY: day.added.toDouble(),
                                  width: 7,
                                  color: AppColors.accentGreen.withValues(
                                    alpha: isDark ? 0.9 : 0.75,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                                BarChartRodData(
                                  toY: day.completed.toDouble(),
                                  width: 7,
                                  color: AppColors.seedGreen,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Added this month',
                      value: '$totalAdded',
                      icon: Icons.add_chart_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Completed this month',
                      value: '$totalCompleted',
                      icon: Icons.verified_outlined,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: muted)),
          ],
        ),
      ),
    );
  }
}