import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/repository/user_repository.dart';

final userControllerProvider =
    Provider((ref) => UserController(ref.watch(userRepositoryProvider), ref));

class UserController {
  final UserRepository _userRepository;
  final Ref _ref;

  UserController(this._userRepository, this._ref);

  void updateUserGoal(
      {required BuildContext context,
      int? pages,
      int? minutes,
      int? type}) async {
    final user = _ref.read(userProvider)!;
    final res = await _userRepository.updateUserDetails(
        uid: user.uid, pages: pages, minutes: minutes, type: type);

    res.fold(
        (l) => showSnackBar(context, 'Some error occurred, please try again!'),
        (r) => showSnackBar(context, 'Goal updated!'));
  }

  void updateNotification({
    required BuildContext context,
    bool? notificationOn,
    TimeOfDay? time,
  }) async {
    final user = _ref.read(userProvider)!;
    final res = await _userRepository.updateUserDetails(
        uid: user.uid, notificationOn: notificationOn, time: time);

    res.fold(
        (l) => showSnackBar(context, 'Some error occurred, please try again!'),
        (r) => showSnackBar(context, 'Reminder updated!'));
  }

  void resetStreak() {
    final user = _ref.read(userProvider)!;
    _userRepository.resetStreak(uid: user.uid);
  }
}
