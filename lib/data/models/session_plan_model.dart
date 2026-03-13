import '../../domain/entities/session_plan.dart';

class SessionPlanModel {
  SessionPlanModel({
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

  factory SessionPlanModel.fromEntity(SessionPlan plan) {
    return SessionPlanModel(
      id: plan.id,
      subject: plan.subject,
      minutes: plan.minutes,
      type: plan.type,
      createdAt: plan.createdAt,
    );
  }

  SessionPlan toEntity() {
    return SessionPlan(
      id: id,
      subject: subject,
      minutes: minutes,
      type: type,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'minutes': minutes,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SessionPlanModel.fromMap(Map<dynamic, dynamic> map) {
    return SessionPlanModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      minutes: map['minutes'] as int,
      type: SessionType.values.firstWhere(
        (value) => value.name == map['type'],
        orElse: () => SessionType.custom,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
