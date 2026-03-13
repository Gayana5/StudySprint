import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/session_plan.dart';
import '../../domain/repositories/session_repository.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit(this._repository) : super(const SessionsState());

  final SessionRepository _repository;
  final Uuid _uuid = const Uuid();

  Future<void> load() async {
    emit(state.copyWith(status: SessionsStatus.loading));
    final plans = await _repository.fetchPlans();
    emit(state.copyWith(status: SessionsStatus.ready, plans: plans));
  }

  Future<void> addPlan({
    required String subject,
    required int minutes,
    required SessionType type,
  }) async {
    final plan = SessionPlan(
      id: _uuid.v4(),
      subject: subject,
      minutes: minutes,
      type: type,
      createdAt: DateTime.now(),
    );
    await _repository.savePlan(plan);
    await load();
  }

  Future<void> deletePlan(String planId) async {
    await _repository.deletePlan(planId);
    await load();
  }
}
