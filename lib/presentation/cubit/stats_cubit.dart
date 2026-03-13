import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/goal_settings.dart';
import '../../domain/entities/session_log.dart';
import '../../domain/entities/stats_summary.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/calculate_stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(
    this._sessionRepository,
    this._settingsRepository,
    this._calculateStats,
  ) : super(const StatsState());

  final SessionRepository _sessionRepository;
  final SettingsRepository _settingsRepository;
  final CalculateStats _calculateStats;

  Future<void> load() async {
    emit(state.copyWith(status: StatsStatus.loading));
    final logs = await _sessionRepository.fetchLogs();
    final goals = await _settingsRepository.loadGoalSettings();
    final summary = _calculateStats(logs: logs, goalSettings: goals);
    emit(state.copyWith(
      status: StatsStatus.ready,
      logs: logs,
      goalSettings: goals,
      summary: summary,
    ));
  }
}
