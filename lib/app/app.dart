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
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A1A),
                  Color(0xFF0A0A0A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Retro neon grid pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: RetroGridPainter(),
                  ),
                ),
                // Animated neon shapes
                const Positioned(
                  top: -60,
                  right: -40,
                  child: AnimatedNeonShape(
                    color: Color(0xFF00FFFF),
                    size: 180,
                    shape: ShapeType.triangle,
                  ),
                ),
                const Positioned(
                  bottom: -70,
                  left: -30,
                  child: AnimatedNeonShape(
                    color: Color(0xFFFF00FF),
                    size: 200,
                    shape: ShapeType.circle,
                  ),
                ),
                const Positioned(
                  top: 220,
                  left: -80,
                  child: AnimatedNeonShape(
                    color: Color(0xFFFFFF00),
                    size: 160,
                    shape: ShapeType.square,
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

enum ShapeType { triangle, circle, square }

class AnimatedNeonShape extends StatefulWidget {
  const AnimatedNeonShape({
    super.key,
    required this.color,
    required this.size,
    required this.shape,
  });

  final Color color;
  final double size;
  final ShapeType shape;

  @override
  State<AnimatedNeonShape> createState() => _AnimatedNeonShapeState();
}

class _AnimatedNeonShapeState extends State<AnimatedNeonShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              border: Border.all(
                color: widget.color,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              shape: widget.shape == ShapeType.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
            ),
            child: widget.shape == ShapeType.triangle
                ? CustomPaint(
                    painter: TrianglePainter(color: widget.color),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RetroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
