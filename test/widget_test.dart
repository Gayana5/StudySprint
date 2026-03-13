import 'package:flutter_test/flutter_test.dart';
import 'package:studysprint/app/app.dart';
import 'package:studysprint/app/service_locator.dart';
import 'package:studysprint/core/services/notification_service.dart';
import 'package:studysprint/domain/entities/goal_settings.dart';
import 'package:studysprint/domain/entities/session_log.dart';
import 'package:studysprint/domain/entities/session_plan.dart';
import 'package:studysprint/domain/repositories/session_repository.dart';
import 'package:studysprint/domain/repositories/settings_repository.dart';
import 'package:studysprint/domain/usecases/calculate_stats.dart';

void main() {
  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton<SessionRepository>(FakeSessionRepository.new);
    sl.registerLazySingleton<SettingsRepository>(FakeSettingsRepository.new);
    sl.registerLazySingleton<NotificationService>(FakeNotificationService.new);
    sl.registerLazySingleton<CalculateStats>(CalculateStats.new);
  });

  testWidgets('StudySprint app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const StudySprintApp());
    await tester.pumpAndSettle();

    expect(find.text('Сессии'), findsOneWidget);
    expect(find.text('Таймер'), findsOneWidget);
    expect(find.text('Статистика'), findsOneWidget);
    expect(find.text('Цели'), findsOneWidget);
  });
}

class FakeSessionRepository implements SessionRepository {
  final List<SessionPlan> _plans = [];
  final List<SessionLog> _logs = [];

  @override
  Future<void> deletePlan(String planId) async {
    _plans.removeWhere((plan) => plan.id == planId);
  }

  @override
  Future<List<SessionLog>> fetchLogs() async => List.of(_logs);

  @override
  Future<List<SessionPlan>> fetchPlans() async => List.of(_plans);

  @override
  Future<void> saveLog(SessionLog log) async {
    _logs.add(log);
  }

  @override
  Future<void> savePlan(SessionPlan plan) async {
    _plans.add(plan);
  }
}

class FakeSettingsRepository implements SettingsRepository {
  GoalSettings _settings = GoalSettings.defaults();

  @override
  Future<GoalSettings> loadGoalSettings() async => _settings;

  @override
  Future<void> saveGoalSettings(GoalSettings settings) async {
    _settings = settings;
  }
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> cancelDailyReminder() async {}

  @override
  Future<void> cancelSessionEnd() async {}

  @override
  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {}

  @override
  Future<void> scheduleSessionEnd({required DateTime scheduledFor, required String subject}) async {}
}
