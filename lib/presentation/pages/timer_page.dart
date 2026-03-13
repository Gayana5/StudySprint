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
                      _TimerRing(
                        remainingSeconds: state.remainingSeconds,
                        totalSeconds: plan.minutes * 60,
                      ),
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
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: OutlinedButton(
                                onPressed: state.isRunning
                                    ? context.read<TimerCubit>().pause
                                    : state.isPaused
                                        ? context.read<TimerCubit>().resume
                                        : null,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFFF00FF),
                                    width: 3,
                                  ),
                                  backgroundColor: state.isRunning || state.isPaused
                                      ? const Color(0xFFFF00FF).withOpacity(0.1)
                                      : null,
                                ),
                                child: Text(
                                  state.isPaused ? 'Продолжить' : 'Пауза',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: FilledButton(
                                onPressed: context.read<TimerCubit>().cancel,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF4444),
                                  shadowColor: const Color(0xFFFF4444).withOpacity(0.5),
                                  elevation: 8,
                                ),
                                child: const Text('Стоп'),
                              ),
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

class _TimerRing extends StatefulWidget {
  const _TimerRing({required this.remainingSeconds, required this.totalSeconds});

  final int remainingSeconds;
  final int totalSeconds;

  @override
  State<_TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<_TimerRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = widget.remainingSeconds ~/ 60;
    final seconds = widget.remainingSeconds % 60;
    final progress = widget.totalSeconds > 0
        ? (widget.totalSeconds - widget.remainingSeconds) / widget.totalSeconds
        : 0.0;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: const Color(0xFF00FFFF), width: 3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FFFF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF00FF)),
                  ),
                ),
                // Timer text with glow
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: const Color(0xFFFFFF00),
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFFFF00).withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                ),
                // Animated border effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00FF00).withOpacity(0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
