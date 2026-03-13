import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../presentation/cubit/sessions_cubit.dart';
import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/stats_cubit.dart';
import '../presentation/cubit/timer_cubit.dart';
import '../presentation/pages/home_page.dart';
import 'service_locator.dart';

class StudySprintApp extends StatelessWidget {
  const StudySprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SessionsCubit(sl())..load(),
        ),
        BlocProvider(
          create: (_) => TimerCubit(sl(), sl()),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(sl(), sl())..load(),
        ),
        BlocProvider(
          create: (_) => StatsCubit(sl(), sl(), sl())..load(),
        ),
      ],
      child: MaterialApp(
        title: 'StudySprint',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF7F3EF),
                  Color(0xFFF1F7F6),
                  Color(0xFFF6F1F7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: -60,
                  right: -40,
                  child: _PastelBlob(
                    color: Color(0xFFB8C4FF),
                    size: 180,
                  ),
                ),
                const Positioned(
                  bottom: -70,
                  left: -30,
                  child: _PastelBlob(
                    color: Color(0xFFBFE7DF),
                    size: 200,
                  ),
                ),
                const Positioned(
                  top: 220,
                  left: -80,
                  child: _PastelBlob(
                    color: Color(0xFFF3C1C9),
                    size: 160,
                  ),
                ),
                if (child != null) child,
              ],
            ),
          );
        },
        home: const HomePage(),
      ),
    );
  }
}

class _PastelBlob extends StatelessWidget {
  const _PastelBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.45),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
