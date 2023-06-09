import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:off_the_shelf/src/features/session/repository/session_repository.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/controller/user_controller.dart';
import 'package:off_the_shelf/src/features/user/repository/user_repository.dart';
import 'package:off_the_shelf/src/models/session.model.dart';

final streakStateProvider =
    StateNotifierProvider<StreakController, StreakState>(
        (ref) => StreakController(
            sessionRepository: ref.read(
              sessionRepositoryProvider,
            ),
            ref: ref));

class DayReadStatus {
  int pages;
  int minutes;

  DayReadStatus(this.pages, this.minutes);

  DayReadStatus copyWith({
    int? pages,
    int? minutes,
  }) {
    return DayReadStatus(
      pages ?? this.pages,
      minutes ?? this.minutes,
    );
  }

  void updateReadStatus(int pages, int minutes) {
    this.pages += pages;
    this.minutes += minutes;
  }
}

class StreakState {
  final Map<String, DayReadStatus> sessionsMap;
  final bool loading;
  final String? error;

  StreakState({this.sessionsMap = const {}, this.loading = false, this.error});

  StreakState copyWith({
    Map<String, DayReadStatus>? sessionsMap,
    bool? loading,
    String? error,
  }) {
    return StreakState(
      sessionsMap: sessionsMap ?? this.sessionsMap,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class StreakController extends StateNotifier<StreakState> {
  final SessionRepository _sessionRepository;
  final Ref _ref;

  StreakController({
    required SessionRepository sessionRepository,
    required Ref ref,
  })  : _sessionRepository = sessionRepository,
        _ref = ref,
        super(StreakState()) {
    final now = DateTime.now();
    final monthStartDay = DateTime(now.year, now.month, 1);
    getSessionsByMonth(monthStartDay);
    checkAndResetCurrentStreak();
  }

  void getSessionsByMonth(DateTime monthStartDay) async {
    final user = _ref.read(userProvider);
    final DateTime nextMonthStartDate =
        DateTime(monthStartDay.year, monthStartDay.month + 1, 1, 23, 59, 59);
    final DateTime endOfMonth =
        nextMonthStartDate.subtract(const Duration(days: 1));

    state = state.copyWith(loading: true);
    final sessionRes = await _sessionRepository.getSessionsInDateRange(
        user!.uid, monthStartDay, endOfMonth);

    state = state.copyWith(loading: false);

    sessionRes.fold((l) {
      state = state.copyWith(error: l.toString());
    }, (sessions) {
      final sessionsMap = createSessionsMap(sessions);
      state = state.copyWith(sessionsMap: sessionsMap);
    });
  }

  void checkAndResetCurrentStreak() async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStart =
        DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0, 0, 0);
    final todayEnd =
        DateTime(today.year, today.month, today.day, 23, 59, 59, 0, 0);

    final sessionRes = await _sessionRepository.getSessionsInDateRange(
        _ref.read(userProvider)!.uid, yesterdayStart, todayEnd);

    sessionRes.fold((l) {
      state = state.copyWith(error: l.toString());
    }, (sessions) {
      if (sessions.isEmpty) {
        _ref.read(userControllerProvider).resetStreak();
      } else {}
    });
  }

  void updateStreak(DateTime startTime) async {
    final today = DateTime.now();
    final todayStart =
        DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    final endCheck = startTime.subtract(const Duration(minutes: 1));
    ;

    final user = _ref.read(userProvider)!;

    final sessionRes = await _sessionRepository.getSessionsInDateRange(
        _ref.read(userProvider)!.uid, todayStart, endCheck);

    sessionRes.fold((l) {
      state = state.copyWith(error: l.toString());
    }, (sessions) {
      if (sessions.isEmpty) {
        _ref.read(userRepositoryProvider).increaseStreak(
            uid: user.uid,
            currentStreak: user.currentStreak! + 1,
            longestStreak: user.longestStreak!);
      }
    });
  }

  Map<String, DayReadStatus> createSessionsMap(List<Session> sessions) {
    final Map<String, DayReadStatus> sessionsMap = {};
    for (var session in sessions) {
      final dateText = DateFormat('dd MM yy').format(session.startTime);
      if (sessionsMap[dateText] != null) {
        sessionsMap[dateText]!.updateReadStatus(session.pages, session.minutes);
      } else {
        sessionsMap[dateText] = DayReadStatus(session.pages, session.minutes);
      }
    }
    return sessionsMap;
  }
}
