import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/session_plan.dart';
import '../cubit/sessions_cubit.dart';
import '../cubit/timer_cubit.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные сессии'),
      ),
      body: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state.status == SessionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.plans.isEmpty) {
            return const Center(
              child: Text('Создайте первую сессию для старта'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.plans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final plan = state.plans[index];
              return Card(
                child: ListTile(
                  title: Text(plan.subject),
                  subtitle: Text('${plan.minutes} мин • ${plan.type.label}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: 'Старт',
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          context.read<TimerCubit>().start(plan);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Таймер запущен'),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Удалить',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          context.read<SessionsCubit>().deletePlan(plan.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final subjectController = TextEditingController();
    final minutesController = TextEditingController(text: '25');
    var type = SessionType.pomodoro;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Новая сессия'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Предмет',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: SessionType.values.map((value) {
                      return ChoiceChip(
                        label: Text(value.label),
                        selected: type == value,
                        onSelected: (_) {
                          setState(() {
                            type = value;
                            if (value == SessionType.pomodoro) {
                              minutesController.text = '25';
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Минуты',
                    ),
                    enabled: type == SessionType.custom,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    final minutes = int.tryParse(minutesController.text) ?? 0;
                    if (subject.isEmpty || minutes <= 0) {
                      return;
                    }
                    context.read<SessionsCubit>().addPlan(
                          subject: subject,
                          minutes: minutes,
                          type: type,
                        );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
    subjectController.dispose();
    minutesController.dispose();
  }
}
