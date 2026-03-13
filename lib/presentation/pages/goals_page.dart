import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal_settings.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/stats_cubit.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цели и мотивация'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state.status == SettingsStatus.ready) {
                context.read<StatsCubit>().load();
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState.status == SettingsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings =
                settingsState.settings ?? GoalSettings.defaults();
            final stats = context.watch<StatsCubit>().state.summary;
            final todayMinutes = stats?.goalProgressMinutes ?? 0;
            final goalMinutes = settings.dailyMinutes;
            final progress = goalMinutes == 0
                ? 0.0
                : (todayMinutes / goalMinutes).clamp(0.0, 1.0);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дневная цель',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        Text('$todayMinutes из $goalMinutes минут'),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => _showGoalDialog(context, settings),
                          child: const Text('Изменить цель'),
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
                          'Серия дней подряд',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${stats?.streakDays ?? 0} дней',
                          style: Theme.of(context).textTheme.headlineSmall,
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
                          'Напоминания',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: settings.reminderEnabled,
                          onChanged: (value) {
                            final updated =
                                settings.copyWith(reminderEnabled: value);
                            context
                                .read<SettingsCubit>()
                                .updateSettings(updated);
                          },
                          title: const Text('Ежедневное напоминание'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Время: ${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                            ),
                            TextButton(
                              onPressed: () =>
                                  _pickReminderTime(context, settings),
                              child: const Text('Изменить'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showGoalDialog(
    BuildContext context,
    GoalSettings settings,
  ) async {
    final controller =
        TextEditingController(text: settings.dailyMinutes.toString());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Новая дневная цель'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Минуты в день',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final minutes = int.tryParse(controller.text) ?? 0;
                if (minutes <= 0) return;
                context.read<SettingsCubit>().updateSettings(
                      settings.copyWith(dailyMinutes: minutes),
                    );
                Navigator.pop(dialogContext);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    GoalSettings settings,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
    );
    if (!context.mounted) return;
    if (time == null) return;
    final updated = settings.copyWith(
      reminderHour: time.hour,
      reminderMinute: time.minute,
    );
    context.read<SettingsCubit>().updateSettings(updated);
  }
}
