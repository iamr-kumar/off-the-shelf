import 'package:fpdart/fpdart.dart';

import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

enum GoalType { pages, minutes }

enum BookStatus { toRead, reading, finished, abandoned }

enum ThemeMode { light, dark }

String describeStatusEnum(BookStatus value) {
  switch (value) {
    case BookStatus.toRead:
      return 'To Read';
    case BookStatus.reading:
      return 'Reading';
    case BookStatus.finished:
      return 'Finished';
    case BookStatus.abandoned:
      return 'Abandoned';
  }
}

BookStatus getStatusFromRouteParam(String value) {
  switch (value) {
    case 'toRead':
      return BookStatus.toRead;
    case 'reading':
      return BookStatus.reading;
    case 'finished':
      return BookStatus.finished;
    case 'abandoned':
      return BookStatus.abandoned;
    default:
      return BookStatus.toRead;
  }
}

String describeGoalTypeEnum(GoalType value) {
  switch (value) {
    case GoalType.pages:
      return 'pages';
    case GoalType.minutes:
      return 'minutes';
  }
}
