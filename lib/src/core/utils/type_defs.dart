import 'package:fpdart/fpdart.dart';

import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

enum GoalType { pages, minutes }

enum BookStatus { toRead, reading, finished, abandoned }

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

String describeGoalTypeEnum(GoalType value) {
  switch (value) {
    case GoalType.pages:
      return 'pages';
    case GoalType.minutes:
      return 'minutes';
  }
}
