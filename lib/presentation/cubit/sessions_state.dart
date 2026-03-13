part of 'sessions_cubit.dart';

enum SessionsStatus { initial, loading, ready }

class SessionsState extends Equatable {
  const SessionsState({
    this.status = SessionsStatus.initial,
    this.plans = const [],
  });

  final SessionsStatus status;
  final List<SessionPlan> plans;

  SessionsState copyWith({
    SessionsStatus? status,
    List<SessionPlan>? plans,
  }) {
    return SessionsState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
    );
  }

  @override
  List<Object?> get props => [status, plans];
}
