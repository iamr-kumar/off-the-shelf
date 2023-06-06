import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:off_the_shelf/src/core/constants/firebase_constants.dart';
import 'package:off_the_shelf/src/core/utils/failure.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/models/session.model.dart';
import 'package:off_the_shelf/src/providers/firebase_providers.dart';

final sessionRepositoryProvider =
    Provider((ref) => SessionRepository(ref.read(firestoreProvider)));

class SessionRepository {
  final FirebaseFirestore _firestore;

  SessionRepository(this._firestore);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid createNewSession(
      {required String bookId,
      required DateTime start,
      required DateTime end,
      required int pages,
      required int minutes,
      required String userId}) async {
    try {
      CollectionReference logs =
          _users.doc(userId).collection(FirebaseConstants.sessionsCollection);
      Session session = Session(
        bookId: bookId,
        startTime: start,
        endTime: end,
        pages: pages,
        minutes: minutes,
      );
      await logs.add(session.toMap());
      return right(null);
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }

  Stream<List<Session>> getLogs(String userId) {
    CollectionReference logs =
        _users.doc(userId).collection(FirebaseConstants.sessionsCollection);
    return logs.snapshots().map((event) {
      return event.docs
          .map((e) => Session.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<Session>> getTodaysSessions(String userId) {
    DateTime now = DateTime.now();
    int today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    CollectionReference sessions =
        _users.doc(userId).collection(FirebaseConstants.sessionsCollection);
    return sessions
        .where('startTime', isGreaterThanOrEqualTo: today)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => Session.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
