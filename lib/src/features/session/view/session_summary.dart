import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/minute_to_page.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/features/session/controller/session_controller.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class SessionSummary extends ConsumerStatefulWidget {
  final int minutes;
  final int seconds;
  final Book book;
  final DateTime startTime;
  final DateTime endTime;
  final BuildContext parentContext;

  const SessionSummary(
      {super.key,
      required this.minutes,
      required this.seconds,
      required this.book,
      required this.startTime,
      required this.endTime,
      required this.parentContext});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionSummaryState();
}

class _SessionSummaryState extends ConsumerState<SessionSummary> {
  late TextEditingController _pagesReadController;

  @override
  void initState() {
    super.initState();
    _pagesReadController = TextEditingController(
        text: getPageFromMinutes(widget.minutes).toString());
  }

  @override
  void dispose() {
    super.dispose();
    _pagesReadController.dispose();
  }

  void logSession() {
    ref.read(sessionControllerProvider.notifier).createNewSession(
        bookId: widget.book.id,
        pages: int.parse(_pagesReadController.text),
        minutes: widget.minutes,
        startTime: widget.startTime,
        endTime: widget.endTime,
        context: widget.parentContext);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Session Summary',
                style: AppStyles.headingFour,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: AppStyles.subtext,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Session Time',
            style: AppStyles.subheading.copyWith(fontSize: 18),
          ),
          Text(
            '${widget.minutes} minutes ${widget.seconds} seconds',
            style: AppStyles.highlightedSubtext,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Book',
            style: AppStyles.subheading.copyWith(fontSize: 18),
          ),
          Text(
            widget.book.title,
            style: AppStyles.highlightedSubtext,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Pages Read',
            style: AppStyles.subheading.copyWith(fontSize: 18),
          ),
          TextField(
            controller: _pagesReadController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(text: 'Finish', onPressed: logSession)
        ],
      ),
    );
  }
}
