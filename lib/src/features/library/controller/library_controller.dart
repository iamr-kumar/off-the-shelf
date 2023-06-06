import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/features/library/repository/library_repository.dart';
import 'package:off_the_shelf/src/models/book.model.dart';

final libraryControllerProvider = Provider(
    (ref) => LibraryController(ref.read(libraryRepositoryProvider), ref));

final booksByStatusProvider = StreamProvider.autoDispose
    .family<List<Book>, BookStatus>((ref, status) =>
        ref.watch(libraryControllerProvider).getBooksByStatus(status));

final recentlyCompletedProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(libraryControllerProvider).getRecentlyCompletedBook());

final allBooksProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(libraryControllerProvider).getAllBooks());

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

  Stream<List<Book>> getAllBooks() {
    return _libraryRepository.getAllBooks();
  }

  Stream<List<Book>> getBooksByStatus(BookStatus status) {
    return _libraryRepository.getBooksByStatus(status);
  }

  Stream<List<Book>> getRecentlyCompletedBook() {
    final today = DateTime.now();
    final oneMonthAgo = today.subtract(const Duration(days: 30));
    return _libraryRepository.getBooksReadFromDate(oneMonthAgo);
  }

  void updateBookProgress(
      BuildContext context, String bookId, int pages) async {
    final bookRes = await _libraryRepository.getBook(bookId);
    late Book book;
    bookRes.fold((l) => null, (r) => {book = r});

    if (book.progress + pages >= book.pageCount) {
      book = book.copyWith(
          progress: book.pageCount,
          status: BookStatus.finished,
          updatedAt: DateTime.now(),
          completedAt: DateTime.now());
    } else {
      book = book.copyWith(
          progress: book.progress + pages, updatedAt: DateTime.now());
    }
    final updatedBook =
        await _ref.read(libraryRepositoryProvider).updateBook(book);

    updatedBook.fold((l) => showSnackBar(context, l.message), (r) {
      const message = 'Updated your daily progress';
      showSnackBar(context, message);
    });
  }

  void updateBookStatus(
      BuildContext context, String bookId, BookStatus status) async {
    final bookRes = await _libraryRepository.getBook(bookId);
    late Book book;
    bookRes.fold((l) => null, (r) => {book = r});

    book = book.copyWith(status: status, updatedAt: DateTime.now());

    final updatedBook =
        await _ref.read(libraryRepositoryProvider).updateBook(book);

    updatedBook.fold((l) => showSnackBar(context, l.message), (r) {
      final message = 'Move book to ${describeStatusEnum(status)}';
      showSnackBar(context, message);
    });
  }
}
