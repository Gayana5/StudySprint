import 'package:intl/intl.dart';

import '../entities/goal_settings.dart';
import '../entities/session_log.dart';
import '../entities/stats_summary.dart';

class CalculateStats {
  StatsSummary call({
    required List<SessionLog> logs,
    required GoalSettings goalSettings,
    DateTime? now,
  }) {
    if (logs.isEmpty) {
      return const StatsSummary(
        totalMinutes: 0,
        averageProductivity: 0,
        minutesBySubject: {},
        streakDays: 0,
        goalProgressMinutes: 0,
      );
    }

    final Map<String, int> minutesBySubject = {};
    var totalMinutes = 0;
    var productivitySum = 0;

    for (final log in logs) {
      totalMinutes += log.durationMinutes;
      productivitySum += log.productivity;
      minutesBySubject.update(
        log.subject,
        (value) => value + log.durationMinutes,
        ifAbsent: () => log.durationMinutes,
      );
    }

    final averageProductivity = productivitySum / logs.length;
    final streakDays = _calculateStreak(logs, goalSettings, now);
    final todayMinutes = _minutesForDate(logs, now ?? DateTime.now());

    return StatsSummary(
      totalMinutes: totalMinutes,
      averageProductivity: averageProductivity,
      minutesBySubject: minutesBySubject,
      streakDays: streakDays,
      goalProgressMinutes: todayMinutes,
    );
  }

  int _calculateStreak(
    List<SessionLog> logs,
    GoalSettings goalSettings,
    DateTime? now,
  ) {
    final target = goalSettings.dailyMinutes;
    if (target <= 0) {
      return 0;
    }

    final effectiveNow = now ?? DateTime.now();
    var streak = 0;
    var cursor = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);

    while (true) {
      final minutes = _minutesForDate(logs, cursor);
      if (minutes >= target) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int _minutesForDate(List<SessionLog> logs, DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    final target = formatter.format(date);
    var total = 0;
    for (final log in logs) {
      if (formatter.format(log.startedAt) == target) {
        total += log.durationMinutes;
      }
    }
    return total;
  }
}
