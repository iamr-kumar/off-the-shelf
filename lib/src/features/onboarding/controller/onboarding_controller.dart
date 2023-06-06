// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/minute_to_page.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/repository/user_repository.dart';
import 'package:off_the_shelf/src/features/library/controller/book_search_controller.dart';
import 'package:off_the_shelf/src/features/library/repository/library_repository.dart';
import 'package:off_the_shelf/src/models/book.model.dart';

class OnboardingState {
  final int? type;
  final int? minutes;
  final int? pages;
  final TimeOfDay? time;
  bool loading;

  OnboardingState({
    this.type = 1,
    this.minutes,
    this.pages,
    this.time,
    this.loading = false,
  });

  OnboardingState copyWith({
    int? type,
    int? minutes,
    int? pages,
    TimeOfDay? time,
    bool? loading,
  }) {
    return OnboardingState(
      type: type ?? this.type,
      minutes: minutes ?? this.minutes,
      pages: pages ?? this.pages,
      time: time ?? this.time,
      loading: loading ?? this.loading,
    );
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
        (ref) => OnboardingController(ref));

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingController(
    this._ref,
  ) : super(OnboardingState());

  void setType(int? type) {
    state = state.copyWith(type: type);
  }

  void setMinutes(int? minutes) {
    state = state.copyWith(minutes: minutes);
  }

  void setPages(int? pages) {
    state = state.copyWith(pages: pages);
  }

  void setTime(TimeOfDay? time) {
    state = state.copyWith(time: time);
  }

  void completeOnboarding(BuildContext context) async {
    state.loading = true;
    Book? book = _ref.read(bookSearchControllerProvider).selectedBook;
    String uid = _ref.read(userProvider)!.uid;
    int? type = state.type;
    int? minutes = state.minutes;
    int? pages = state.pages;
    TimeOfDay? time = state.time;
    if (book == null) {
      return showSnackBar(context, 'Please select a book');
    }
    final newBook =
        await _ref.read(libraryRepositoryProvider).addBookToLibrary(book);

    if (minutes != null) {
      pages = getPageFromMinutes(minutes);
    }
    if (pages != null) {
      minutes = getMinutesFromPage(pages);
    }

    newBook.fold((l) {
      state.loading = false;
      showSnackBar(context, l.message);
    }, (r) async {
      final res = await _ref.read(userRepositoryProvider).updateSessionDetails(
          uid: uid,
          bookUid: book.id,
          type: type,
          minutes: minutes,
          time: time,
          pages: pages,
          markOnboardingComplete: true);
      state.loading = false;
      res.fold((l) => showSnackBar(context, l.message), (r) async {});
    });
  }
}
