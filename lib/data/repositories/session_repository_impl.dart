import '../../domain/entities/session_log.dart';
import '../../domain/entities/session_plan.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_local_datasource.dart';
import '../models/session_log_model.dart';
import '../models/session_plan_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._localDataSource);

  final SessionLocalDataSource _localDataSource;

  @override
  Future<List<SessionPlan>> fetchPlans() async {
    final models = _localDataSource.fetchPlans();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> savePlan(SessionPlan plan) async {
    await _localDataSource.savePlan(SessionPlanModel.fromEntity(plan));
  }

  @override
  Future<void> deletePlan(String planId) async {
    await _localDataSource.deletePlan(planId);
  }

  @override
  Future<List<SessionLog>> fetchLogs() async {
    final models = _localDataSource.fetchLogs();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveLog(SessionLog log) async {
    await _localDataSource.saveLog(SessionLogModel.fromEntity(log));
  }
}
