import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/features/auth/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/session/repository/session_repository.dart';
import 'package:off_the_shelf/src/models/session.model.dart';

final sessionControllerProvider =
    StateNotifierProvider<SessionController, bool>(
        (ref) => SessionController(ref.read(sessionRepositoryProvider), ref));
final todaysProgressProvider = StreamProvider.autoDispose<List<Session>>((ref) {
  return ref.read(sessionControllerProvider.notifier).getTodaysSessions();
});

class SessionController extends StateNotifier<bool> {
  final Ref _ref;
  final SessionRepository _sessionRepository;

  SessionController(this._sessionRepository, this._ref) : super(false);

  void createNewSession(
      {required String bookId,
      required int pages,
      required int minutes,
      required DateTime startTime,
      required DateTime endTime,
      required BuildContext context}) async {
    state = true;
    final userId = _ref.read(userProvider)!.uid;
    final readingLog = await _sessionRepository.createNewSession(
      userId: userId,
      bookId: bookId,
      pages: pages,
      minutes: minutes,
      start: startTime,
      end: endTime,
    );
    state = false;

    readingLog.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(libraryControllerProvider)
          .updateBookProgress(context, bookId, pages);
      showSnackBar(context, 'Session logged successfully');
    });
  }

  Stream<List<Session>> getTodaysSessions() {
    final userId = _ref.read(userProvider)!.uid;
    return _sessionRepository.getTodaysSessions(userId);
  }
}
