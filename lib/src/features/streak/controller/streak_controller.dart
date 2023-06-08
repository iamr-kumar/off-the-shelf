import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/features/session/repository/session_repository.dart';
import 'package:off_the_shelf/src/models/session.model.dart';

final streakStateProvider =
    StateNotifierProvider<StreakController, StreakState>((ref) =>
        StreakController(
            sessionRepository: ref.read(sessionRepositoryProvider)));

class StreakState {
  final List<Session> sessions;
  final bool loading;
  final String? error;

  StreakState({this.sessions = const [], this.loading = false, this.error});

  StreakState copyWith({
    List<Session>? sessions,
    bool? loading,
    String? error,
  }) {
    return StreakState(
      sessions: sessions ?? this.sessions,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class StreakController extends StateNotifier<StreakState> {
  final SessionRepository _sessionRepository;

  StreakController({
    required SessionRepository sessionRepository,
  })  : _sessionRepository = sessionRepository,
        super(StreakState()) {
    final now = DateTime.now();
    final monthStartDay = DateTime(now.year, now.month, 1);
    getSessionsByMonth(monthStartDay);
  }

  void getSessionsByMonth(DateTime monthStartDay) async {
    final DateTime nextMonthStartDate =
        DateTime(monthStartDay.year, monthStartDay.month + 1, 1);
    final DateTime endOfMonth =
        nextMonthStartDate.subtract(const Duration(days: 1));
    state = state.copyWith(loading: true);
    final sessionRes = await _sessionRepository.getSessionsInDateRange(
        monthStartDay, endOfMonth);

    state = state.copyWith(loading: false);

    sessionRes.fold((l) {
      state = state.copyWith(error: l.toString());
    }, (sessions) {
      state = state.copyWith(sessions: sessions);
    });
  }
}
