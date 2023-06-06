import 'package:off_the_shelf/src/core/utils/type_defs.dart';

String getProgressMessage(double percent) {
  if (percent < 20) {
    return 'You are just getting started';
  } else if (percent < 50) {
    return 'You are halfway there';
  } else if (percent < 80) {
    return 'You are almost done';
  } else {
    return 'Yay! Goal completed';
  }
}

String getStatusMessage(
    GoalType type, int goalPages, int goalMinutes, int pages, int minutes) {
  String message = "You have read";
  if (type == GoalType.minutes) {
    message += " $minutes/$goalMinutes  minutes";
  } else {
    message += " $pages/$goalPages pages";
  }
  return "$message today";
}
