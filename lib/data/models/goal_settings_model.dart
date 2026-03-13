import '../../domain/entities/goal_settings.dart';

class GoalSettingsModel {
  GoalSettingsModel({
    required this.dailyMinutes,
    required this.reminderEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  final int dailyMinutes;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  factory GoalSettingsModel.fromEntity(GoalSettings settings) {
    return GoalSettingsModel(
      dailyMinutes: settings.dailyMinutes,
      reminderEnabled: settings.reminderEnabled,
      reminderHour: settings.reminderHour,
      reminderMinute: settings.reminderMinute,
    );
  }

  GoalSettings toEntity() {
    return GoalSettings(
      dailyMinutes: dailyMinutes,
      reminderEnabled: reminderEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyMinutes': dailyMinutes,
      'reminderEnabled': reminderEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  factory GoalSettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return GoalSettingsModel(
      dailyMinutes: map['dailyMinutes'] as int,
      reminderEnabled: map['reminderEnabled'] as bool,
      reminderHour: map['reminderHour'] as int,
      reminderMinute: map['reminderMinute'] as int,
    );
  }
}
