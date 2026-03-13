import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/notification_service.dart';
import '../../domain/entities/session_log.dart';
import '../../domain/entities/session_plan.dart';
import '../../domain/repositories/session_repository.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit(this._repository, this._notifications)
      : super(const TimerState());

  final SessionRepository _repository;
  final NotificationService _notifications;
  final Uuid _uuid = const Uuid();

  Timer? _ticker;

  void start(SessionPlan plan) {
    _ticker?.cancel();
    final startedAt = DateTime.now();
    final endAt = startedAt.add(Duration(minutes: plan.minutes));
    emit(TimerState.running(
      plan: plan,
      startedAt: startedAt,
      endAt: endAt,
      remainingSeconds: endAt.difference(startedAt).inSeconds,
    ));
    _notifications.scheduleSessionEnd(
      scheduledFor: endAt,
      subject: plan.subject,
    );
    _startTicker();
  }

  void pause() {
    if (!state.isRunning) return;
    _ticker?.cancel();
    _notifications.cancelSessionEnd();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void resume() {
    if (!state.isPaused) return;
    final endAt = DateTime.now().add(Duration(seconds: state.remainingSeconds));
    emit(state.copyWith(status: TimerStatus.running, endAt: endAt));
    _notifications.scheduleSessionEnd(
      scheduledFor: endAt,
      subject: state.plan?.subject ?? 'Сессия',
    );
    _startTicker();
  }

  void cancel() {
    _ticker?.cancel();
    _notifications.cancelSessionEnd();
    emit(const TimerState());
  }

  Future<void> complete(int productivity) async {
    final plan = state.plan;
    final startedAt = state.startedAt;
    final endAt = DateTime.now();
    if (plan == null || startedAt == null) {
      return;
    }

    final durationMinutes =
        endAt.difference(startedAt).inMinutes.clamp(1, 600);

    final log = SessionLog(
      id: _uuid.v4(),
      subject: plan.subject,
      startedAt: startedAt,
      endedAt: endAt,
      durationMinutes: durationMinutes,
      productivity: productivity,
    );
    await _repository.saveLog(log);
    cancel();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final endAt = state.endAt;
      if (endAt == null) {
        return;
      }
      final remaining = endAt.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _ticker?.cancel();
        emit(state.copyWith(
          status: TimerStatus.completed,
          remainingSeconds: 0,
        ));
      } else {
        emit(state.copyWith(remainingSeconds: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
