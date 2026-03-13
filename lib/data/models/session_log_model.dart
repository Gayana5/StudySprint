import '../../domain/entities/session_log.dart';

class SessionLogModel {
  SessionLogModel({
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
  final int productivity;

  factory SessionLogModel.fromEntity(SessionLog log) {
    return SessionLogModel(
      id: log.id,
      subject: log.subject,
      startedAt: log.startedAt,
      endedAt: log.endedAt,
      durationMinutes: log.durationMinutes,
      productivity: log.productivity,
    );
  }

  SessionLog toEntity() {
    return SessionLog(
      id: id,
      subject: subject,
      startedAt: startedAt,
      endedAt: endedAt,
      durationMinutes: durationMinutes,
      productivity: productivity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'productivity': productivity,
    };
  }

  factory SessionLogModel.fromMap(Map<dynamic, dynamic> map) {
    return SessionLogModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      startedAt: DateTime.parse(map['startedAt'] as String),
      endedAt: DateTime.parse(map['endedAt'] as String),
      durationMinutes: map['durationMinutes'] as int,
      productivity: map['productivity'] as int,
    );
  }
}
