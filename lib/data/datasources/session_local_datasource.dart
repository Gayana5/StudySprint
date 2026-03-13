import 'package:hive/hive.dart';

import '../models/session_log_model.dart';
import '../models/session_plan_model.dart';

class SessionLocalDataSource {
  SessionLocalDataSource({
    required Box<Map> plansBox,
    required Box<Map> logsBox,
  })  : _plansBox = plansBox,
        _logsBox = logsBox;

  final Box<Map> _plansBox;
  final Box<Map> _logsBox;

  List<SessionPlanModel> fetchPlans() {
    return _plansBox.values
        .map((map) => SessionPlanModel.fromMap(map))
        .toList();
  }

  Future<void> savePlan(SessionPlanModel plan) async {
    await _plansBox.put(plan.id, plan.toMap());
  }

  Future<void> deletePlan(String planId) async {
    await _plansBox.delete(planId);
  }

  List<SessionLogModel> fetchLogs() {
    return _logsBox.values
        .map((map) => SessionLogModel.fromMap(map))
        .toList();
  }

  Future<void> saveLog(SessionLogModel log) async {
    await _logsBox.put(log.id, log.toMap());
  }
}
