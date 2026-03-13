import 'package:equatable/equatable.dart';

class GoalSettings extends Equatable {
  const GoalSettings({
    required this.dailyMinutes,
    required this.reminderEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  final int dailyMinutes;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  GoalSettings copyWith({
    int? dailyMinutes,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return GoalSettings(
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  @override
  List<Object?> get props => [
        dailyMinutes,
        reminderEnabled,
        reminderHour,
        reminderMinute,
      ];

  static GoalSettings defaults() {
    return const GoalSettings(
      dailyMinutes: 120,
      reminderEnabled: false,
      reminderHour: 9,
      reminderMinute: 0,
    );
  }
}
