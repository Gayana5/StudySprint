import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/date_format.dart';
import '../../domain/entities/session_plan.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/timer_cubit.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listenWhen: (previous, current) => current.isCompleted,
      listener: (context, state) async {
        if (state.isCompleted) {
          final rating = await _showProductivityDialog(context);
          if (!context.mounted) return;
          if (rating != null) {
            await context.read<TimerCubit>().complete(rating);
            await context.read<StatsCubit>().load();
          }
        }
      },
      builder: (context, state) {
        final plan = state.plan;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Таймер'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: plan == null
                ? const Center(
                    child: Text('Выберите сессию на вкладке "Сессии"'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.subject,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('${plan.minutes} мин • ${plan.type.label}'),
                      const SizedBox(height: 24),
                      _TimerRing(remainingSeconds: state.remainingSeconds),
                      const SizedBox(height: 16),
                      if (state.startedAt != null)
                        Text(
                          'Старт: ${formatTime(state.startedAt!)}',
                        ),
                      if (state.endAt != null)
                        Text(
                          'Финиш: ${formatTime(state.endAt!)}',
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: state.isRunning
                                  ? context.read<TimerCubit>().pause
                                  : state.isPaused
                                      ? context.read<TimerCubit>().resume
                                      : null,
                              child: Text(
                                state.isPaused ? 'Продолжить' : 'Пауза',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: context.read<TimerCubit>().cancel,
                              child: const Text('Стоп'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<int?> _showProductivityDialog(BuildContext context) {
    var rating = 3;
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Как прошла сессия?'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Оцените продуктивность: $rating'),
                  Slider(
                    value: rating.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: rating.toString(),
                    onChanged: (value) {
                      setState(() => rating = value.round());
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Позже'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, rating),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}

class _TimerRing extends StatelessWidget {
  const _TimerRing({required this.remainingSeconds});

  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF8),
        border: Border.all(color: const Color(0xFFE2E6E1), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
