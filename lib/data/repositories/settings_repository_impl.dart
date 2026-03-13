import '../../domain/entities/goal_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/goal_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<GoalSettings> loadGoalSettings() async {
    final model = _localDataSource.loadGoalSettings();
    return model?.toEntity() ?? GoalSettings.defaults();
  }

  @override
  Future<void> saveGoalSettings(GoalSettings settings) async {
    await _localDataSource.saveGoalSettings(
      GoalSettingsModel.fromEntity(settings),
    );
  }
}
