import 'package:hive/hive.dart';

import '../models/goal_settings_model.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._settingsBox);

  final Box<Map> _settingsBox;
  static const _goalKey = 'goal_settings';

  GoalSettingsModel? loadGoalSettings() {
    final map = _settingsBox.get(_goalKey);
    if (map == null) {
      return null;
    }
    return GoalSettingsModel.fromMap(map);
  }

  Future<void> saveGoalSettings(GoalSettingsModel settings) async {
    await _settingsBox.put(_goalKey, settings.toMap());
  }
}
