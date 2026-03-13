import 'package:equatable/equatable.dart';

class SessionPlan extends Equatable {
  const SessionPlan({
    required this.id,
    required this.subject,
    required this.minutes,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String subject;
  final int minutes;
  final SessionType type;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, subject, minutes, type, createdAt];
}

enum SessionType {
  pomodoro,
  custom,
}

extension SessionTypeX on SessionType {
  String get label {
    switch (this) {
      case SessionType.pomodoro:
        return 'Pomodoro';
      case SessionType.custom:
        return 'Custom';
    }
  }
}
