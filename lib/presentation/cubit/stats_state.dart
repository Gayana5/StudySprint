part of 'stats_cubit.dart';

enum StatsStatus { initial, loading, ready }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.logs = const [],
    this.goalSettings,
    this.summary,
  });

  final StatsStatus status;
  final List<SessionLog> logs;
  final GoalSettings? goalSettings;
  final StatsSummary? summary;

  StatsState copyWith({
    StatsStatus? status,
    List<SessionLog>? logs,
    GoalSettings? goalSettings,
    StatsSummary? summary,
  }) {
    return StatsState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      goalSettings: goalSettings ?? this.goalSettings,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [status, logs, goalSettings, summary];
}
