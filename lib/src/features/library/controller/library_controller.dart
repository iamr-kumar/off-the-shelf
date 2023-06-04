import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/features/library/repository/library_repository.dart';
import 'package:off_the_shelf/src/models/book.model.dart';

final libraryControllerProvider = Provider(
    (ref) => LibraryController(ref.read(libraryRepositoryProvider), ref));

class LibraryController {
  final LibraryRepository _libraryRepository;
  final Ref _ref;

  LibraryController(this._libraryRepository, this._ref);

  void addBook(
      Book book, BuildContext context, int status, String? progress) async {
    book = book.copyWith(status: BookStatus.values[status]);

    if (progress != null && status == 1) {
      book = book.copyWith(progress: int.parse(progress));
    }

    book = book.copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now());

    final result = await _libraryRepository.addBookToLibrary(book);

    result.fold((l) => showSnackBar(context, l.message), (book) {
      const message = "Book added to library";
      showSnackBar(context, message);
    });
  }
}
