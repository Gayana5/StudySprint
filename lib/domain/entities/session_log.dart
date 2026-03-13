import 'package:equatable/equatable.dart';

class SessionLog extends Equatable {
  const SessionLog({
    required this.id,
    required this.subject,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.productivity,
  });

  final String id;
  final String subject;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMinutes;
  final int productivity; // 1-5

  @override
  List<Object?> get props => [
        id,
        subject,
        startedAt,
        endedAt,
        durationMinutes,
        productivity,
      ];
}
