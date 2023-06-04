import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/features/library/repository/library_repository.dart';

import 'package:off_the_shelf/src/models/book.model.dart';

final bookSearchControllerProvider =
    StateNotifierProvider<BookSearchController, BookSelectionState>(
        (ref) => BookSearchController(ref.watch(libraryRepositoryProvider)));

class BookSelectionState {
  final Book? selectedBook;
  final List<Book> searchedBooks;
  final bool isLoading;
  final String? error;

  BookSelectionState({
    this.selectedBook,
    this.searchedBooks = const [],
    this.isLoading = false,
    this.error,
  });

  BookSelectionState copyWith({
    Book? book,
    List<Book>? searchedBooks,
    bool? isLoading,
    String? error,
  }) {
    return BookSelectionState(
      selectedBook: book ?? selectedBook,
      searchedBooks: searchedBooks ?? this.searchedBooks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BookSearchController extends StateNotifier<BookSelectionState> {
  final LibraryRepository _libraryRepository;

  BookSearchController(this._libraryRepository) : super(BookSelectionState());

  void searchBooks(String query, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final books = await _libraryRepository.searchBooks(query);
    books.fold((l) {
      state = state.copyWith(isLoading: false, error: l.message);

      showSnackBar(context, l.message);
    }, (books) {
      books = books.where((e) => e.pageCount > 0).toList();
      state = state.copyWith(searchedBooks: books, isLoading: false);
    });
  }

  void selectBook(Book book, int? status, String? progress) {
    if (status != null) {
      book = book.copyWith(status: BookStatus.values[status]);
    }
    if (progress != null && status == 1) {
      book = book.copyWith(progress: int.parse(progress));
    }
    state = state.copyWith(book: book);
  }
}
