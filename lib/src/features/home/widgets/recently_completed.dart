import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/library/widgets/book_tile.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class RecentlyCompleted extends ConsumerWidget {
  const RecentlyCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    return SizedBox(
        height: null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recently Completed', style: AppStyles.subheading),
            const SizedBox(height: 16),
            ref.watch(recentlyCompletedProvider).when(
                data: (data) {
                  return data.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('It\'s been quiet here...',
                                style: AppStyles.highlightedSubtext),
                            Text('Start reading to see your progress here',
                                style: AppStyles.bodyText),
                          ],
                        )
                      : Expanded(
                          child: SizedBox(
                              height: devHeight * 0.3,
                              child: BookTile(
                                book: data[0],
                                height: devHeight,
                              )),
                        );
                },
                loading: () => const Loader(),
                error: (error, stack) {
                  return const ErrorText(error: "Some error occurred");
                })
          ],
        ));
    ;
  }
}
