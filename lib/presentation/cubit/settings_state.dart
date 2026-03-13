part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, ready }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings,
  });

  final SettingsStatus status;
  final GoalSettings? settings;

  SettingsState copyWith({
    SettingsStatus? status,
    GoalSettings? settings,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [status, settings];
}
