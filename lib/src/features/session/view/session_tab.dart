import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/minute_to_page.dart';
import 'package:off_the_shelf/src/core/utils/show_goal_dialog.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/session/view/session_summary.dart';
import 'package:off_the_shelf/src/features/session/widgets/book_selector.dart';
import 'package:off_the_shelf/src/features/session/widgets/reading_timer.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class ReadingSessionTab extends ConsumerStatefulWidget {
  const ReadingSessionTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReadingSessionTabState();
}

class _ReadingSessionTabState extends ConsumerState<ReadingSessionTab> {
  int? _pages;
  int? _minutes;
  final TextEditingController _targetController = TextEditingController();
  late Book bookToRead;
  bool isDisabled = false;

  int type = 1;

  @override
  void dispose() {
    super.dispose();
    _targetController.dispose();
  }

  void updateType(int? value) {
    if (value != null) {
      setState(() {
        type = value;
      });
    }
  }

  void updateBook(Book book) {
    setState(() {
      bookToRead = book;
    });
  }

  void updateTarget(String text) {
    if (type == 0) {
      setState(() {
        _pages = int.parse(text);
        _minutes = getMinutesFromPage(_pages!);
      });
    } else {
      setState(() {
        _minutes = int.parse(text);
        _pages = getPageFromMinutes(_minutes!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    final user = ref.watch(userProvider)!;

    final readingTimeInSeconds =
        _minutes != null ? _minutes! * 60 : user.minutes! * 60;

    void showSummary(
        int minutes, int seconds, DateTime startTime, DateTime endTime) {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          isDismissible: false,
          isScrollControlled: true,
          builder: (ctx) {
            return SizedBox(
              height: deviceHeight * 0.5,
              child: SessionSummary(
                minutes: minutes,
                seconds: seconds,
                book: bookToRead,
                startTime: startTime,
                endTime: endTime,
              ),
            );
          });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Start Reading', style: AppStyles.headingFour)),
                const SizedBox(height: 40),
                ReadingTimer(
                  goalTime: readingTimeInSeconds,
                  onSessionComplete: showSummary,
                  isDisabled: isDisabled,
                ),
                const SizedBox(height: 40),
                const Text(
                  'You\'re reading',
                  style: AppStyles.subheading,
                ),
                ref.watch(booksByStatusProvider(BookStatus.reading)).when(
                    data: (currentlyReading) {
                      if (currentlyReading.isEmpty) {
                        setState(() {
                          isDisabled = true;
                        });
                        return const Text('Pick a book to start reading',
                            style: AppStyles.highlightedSubtext);
                      } else {
                        updateBook(currentlyReading.first);
                        return BookSelector(
                          currentlyReading: currentlyReading,
                          onBookChange: updateBook,
                        );
                      }
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader()),
                const SizedBox(height: 10),
                const Text(
                  'for',
                  style: AppStyles.subheading,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_minutes ?? user.minutes} minutes',
                        style: AppStyles.highlightedSubtext,
                      ),
                      IconButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return showGoalDialog(
                                      context: context,
                                      targetController: _targetController,
                                      type: type,
                                      updateType: updateType);
                                });

                            if (_targetController.text.isNotEmpty) {
                              updateTarget(_targetController.text);
                            }
                          },
                          icon: const Icon(
                            FeatherIcons.edit,
                            size: 20,
                          ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
