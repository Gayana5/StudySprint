import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/notification_service.dart';
import '../../domain/entities/goal_settings.dart';
import '../../domain/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository, this._notifications)
      : super(const SettingsState());

  final SettingsRepository _repository;
  final NotificationService _notifications;

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final settings = await _repository.loadGoalSettings();
    emit(state.copyWith(status: SettingsStatus.ready, settings: settings));

    if (settings.reminderEnabled) {
      await _notifications.scheduleDailyReminder(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      );
    }
  }

  Future<void> updateSettings(GoalSettings settings) async {
    await _repository.saveGoalSettings(settings);
    emit(state.copyWith(status: SettingsStatus.ready, settings: settings));

    if (settings.reminderEnabled) {
      await _notifications.scheduleDailyReminder(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      );
    } else {
      await _notifications.cancelDailyReminder();
    }
  }
}
