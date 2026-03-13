import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/services/notification_service.dart';
import '../data/datasources/session_local_datasource.dart';
import '../data/datasources/settings_local_datasource.dart';
import '../data/repositories/session_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/session_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/usecases/calculate_stats.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  await Hive.initFlutter();

  final plansBox = await Hive.openBox<Map>('plans');
  final logsBox = await Hive.openBox<Map>('logs');
  final settingsBox = await Hive.openBox<Map>('settings');

  sl.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSource(plansBox: plansBox, logsBox: logsBox),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(settingsBox),
  );

  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(sl<SessionLocalDataSource>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );

  sl.registerLazySingleton<NotificationService>(NotificationService.new);
  sl.registerLazySingleton<CalculateStats>(CalculateStats.new);
}
