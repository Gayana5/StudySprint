part of 'timer_cubit.dart';

enum TimerStatus { idle, running, paused, completed }

class TimerState extends Equatable {
  const TimerState({
    this.status = TimerStatus.idle,
    this.plan,
    this.startedAt,
    this.endAt,
    this.remainingSeconds = 0,
  });

  factory TimerState.running({
    required SessionPlan plan,
    required DateTime startedAt,
    required DateTime endAt,
    required int remainingSeconds,
  }) {
    return TimerState(
      status: TimerStatus.running,
      plan: plan,
      startedAt: startedAt,
      endAt: endAt,
      remainingSeconds: remainingSeconds,
    );
  }

  final TimerStatus status;
  final SessionPlan? plan;
  final DateTime? startedAt;
  final DateTime? endAt;
  final int remainingSeconds;

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isCompleted => status == TimerStatus.completed;

  TimerState copyWith({
    TimerStatus? status,
    SessionPlan? plan,
    DateTime? startedAt,
    DateTime? endAt,
    int? remainingSeconds,
  }) {
    return TimerState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      startedAt: startedAt ?? this.startedAt,
      endAt: endAt ?? this.endAt,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        plan,
        startedAt,
        endAt,
        remainingSeconds,
      ];
}
