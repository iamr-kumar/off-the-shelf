import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:off_the_shelf/src/core/constants/firebase_constants.dart';
import 'package:off_the_shelf/src/core/utils/failure.dart';
import 'package:off_the_shelf/src/core/utils/handle_time.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/providers/firebase_providers.dart';

final userRepositoryProvider =
    Provider((ref) => UserRepository(firestore: ref.read(firestoreProvider)));

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid updateUserDetails(
      {required String uid,
      String? bookUid,
      TimeOfDay? time,
      int? pages,
      int? minutes,
      int? type,
      bool? markOnboardingComplete = true}) async {
    final fieldsToUpdate = <String, dynamic>{};
    if (bookUid != null) fieldsToUpdate['readingBook'] = bookUid;
    if (pages != null) fieldsToUpdate['pages'] = pages;
    if (minutes != null) fieldsToUpdate['minutes'] = minutes;
    if (type != null) fieldsToUpdate['goalType'] = type;
    if (time != null) {
      fieldsToUpdate['notifyAt'] = toTimestamp(time);
      fieldsToUpdate['notificationOn'] = true;
    }

    if (markOnboardingComplete != null) {
      fieldsToUpdate['onboardingComplete'] = markOnboardingComplete;
    }

    try {
      return right(_users.doc(uid).update(fieldsToUpdate));
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }
}
