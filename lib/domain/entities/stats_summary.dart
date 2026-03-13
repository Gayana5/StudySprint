import 'package:equatable/equatable.dart';

class StatsSummary extends Equatable {
  const StatsSummary({
    required this.totalMinutes,
    required this.averageProductivity,
    required this.minutesBySubject,
    required this.streakDays,
    required this.goalProgressMinutes,
  });

  final int totalMinutes;
  final double averageProductivity;
  final Map<String, int> minutesBySubject;
  final int streakDays;
  final int goalProgressMinutes;

  @override
  List<Object?> get props => [
        totalMinutes,
        averageProductivity,
        minutesBySubject,
        streakDays,
        goalProgressMinutes,
      ];
}
