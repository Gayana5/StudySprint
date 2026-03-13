import '../entities/goal_settings.dart';

abstract class SettingsRepository {
  Future<GoalSettings> loadGoalSettings();
  Future<void> saveGoalSettings(GoalSettings settings);
}
