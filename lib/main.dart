import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/service_locator.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await sl<NotificationService>().init();
  runApp(const StudySprintApp());
}
