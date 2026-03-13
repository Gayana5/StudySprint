import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stats_summary.dart';
import '../cubit/stats_cubit.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<StatsCubit>().load(),
          ),
        ],
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          if (state.status == StatsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = state.summary;
          if (summary == null) {
            return const Center(child: Text('Нет данных для анализа'));
          }

          final minutesBySubject = summary.minutesBySubject.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatsHeader(summary: summary),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Время по предметам',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      if (minutesBySubject.isEmpty)
                        const Text('Нет данных для графика')
                      else
                        SizedBox(
                          height: 220,
                          child: BarChart(_buildBarData(minutesBySubject)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Детализация',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      ...minutesBySubject.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text('${entry.value} мин'),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  BarChartData _buildBarData(List<MapEntry<String, int>> entries) {
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < entries.length; i++) {
      final value = entries[i].value.toDouble();
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 18,
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1F8A70),
            ),
          ],
        ),
      );
    }

    return BarChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= entries.length) {
                return const SizedBox.shrink();
              }
              final label = entries[index].key;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  label.length > 6 ? '${label.substring(0, 6)}…' : label,
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      barGroups: barGroups,
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.summary});

  final StatsSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Всего минут',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Text(
                        summary.totalMinutes.toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Средняя оценка',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Text(
                        summary.averageProductivity.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Streak',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${summary.streakDays} дней',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Сегодня',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${summary.goalProgressMinutes} мин',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
