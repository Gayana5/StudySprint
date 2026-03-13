import 'package:flutter_test/flutter_test.dart';
import 'package:studysprint/domain/entities/goal_settings.dart';
import 'package:studysprint/domain/entities/session_log.dart';
import 'package:studysprint/domain/usecases/calculate_stats.dart';

void main() {
  test('calculates totals, averages, and streak', () {
    final logs = [
      SessionLog(
        id: '1',
        subject: 'Math',
        startedAt: DateTime(2026, 3, 12, 9),
        endedAt: DateTime(2026, 3, 12, 9, 30),
        durationMinutes: 30,
        productivity: 4,
      ),
      SessionLog(
        id: '2',
        subject: 'Physics',
        startedAt: DateTime(2026, 3, 12, 12),
        endedAt: DateTime(2026, 3, 12, 12, 45),
        durationMinutes: 45,
        productivity: 5,
      ),
      SessionLog(
        id: '3',
        subject: 'Math',
        startedAt: DateTime(2026, 3, 11, 10),
        endedAt: DateTime(2026, 3, 11, 10, 30),
        durationMinutes: 30,
        productivity: 3,
      ),
    ];

    final calculator = CalculateStats();
    final summary = calculator(
      logs: logs,
      goalSettings: const GoalSettings(
        dailyMinutes: 60,
        reminderEnabled: false,
        reminderHour: 9,
        reminderMinute: 0,
      ),
      now: DateTime(2026, 3, 12, 20),
    );

    expect(summary.totalMinutes, 105);
    expect(summary.averageProductivity, closeTo(4.0, 0.01));
    expect(summary.minutesBySubject['Math'], 60);
    expect(summary.minutesBySubject['Physics'], 45);
    expect(summary.streakDays, 1);
    expect(summary.goalProgressMinutes, 75);
  });
}
