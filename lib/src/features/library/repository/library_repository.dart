import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:off_the_shelf/src/core/config/api_keys.dart';
import 'package:off_the_shelf/src/core/constants/firebase_constants.dart';
import 'package:off_the_shelf/src/core/utils/failure.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/features/auth/controller/auth_controller.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/providers/firebase_providers.dart';

final libraryRepositoryProvider = Provider((ref) =>
    LibraryRepository(firestore: ref.read(firestoreProvider), ref: ref));

class LibraryRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  final _startIndex = 0;
  final _maxResults = 10;

  LibraryRepository({required FirebaseFirestore firestore, required Ref ref})
      : _firestore = firestore,
        _ref = ref;

  CollectionReference get _books => _firestore
      .collection(FirebaseConstants.usersCollection)
      .doc(_ref.read(userProvider)!.uid)
      .collection(FirebaseConstants.libraryCollection);

  FutureEither<List<Book>> searchBooks(String query) async {
    String apiKey;
    if (defaultTargetPlatform == TargetPlatform.android) {
      apiKey = ApiKeys.apiKeyAndroid;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      apiKey = ApiKeys.apiKeyIOS;
    } else {
      apiKey = ApiKeys.apiKey;
    }
    final uri = Uri.parse('${ApiKeys.apiBaseUrl}${ApiKeys.apiPath}')
        .replace(queryParameters: {
      'q': query,
      'key': apiKey,
      'startIndex': _startIndex.toString(),
      'endIndex': _maxResults.toString(),
    });
    final response = await get(uri);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      List<dynamic> books = body['items'];

      return right(books
          .map(
              (book) => Book.fromMap({...book['volumeInfo'], "id": book["id"]}))
          .toList());
    } else {
      throw left(Failure('Failed to load books'));
    }
  }

  FutureVoid addBookToLibrary(Book book) async {
    try {
      return right(_books.doc(book.id).set(book.toMap()));
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }
}
