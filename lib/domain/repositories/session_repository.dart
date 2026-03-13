import '../entities/session_log.dart';
import '../entities/session_plan.dart';

abstract class SessionRepository {
  Future<List<SessionPlan>> fetchPlans();
  Future<void> savePlan(SessionPlan plan);
  Future<void> deletePlan(String planId);

  Future<List<SessionLog>> fetchLogs();
  Future<void> saveLog(SessionLog log);
}
