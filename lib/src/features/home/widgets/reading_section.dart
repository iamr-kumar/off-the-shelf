import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/library/widgets/book_tile.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class ReadingSection extends ConsumerWidget {
  const ReadingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    return SizedBox(
        height: devHeight * 0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Currently Reading', style: AppStyles.subheading),
            const SizedBox(height: 16),
            ref.watch(booksByStatusProvider(BookStatus.reading)).when(
                data: (data) {
                  return data.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('It\'s so quiet here...',
                                style: AppStyles.highlightedSubtext),
                            Text('Pick a book to start reading',
                                style: AppStyles.bodyText),
                          ],
                        )
                      : Expanded(
                          child: SizedBox(
                            height: devHeight * 0.3,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return BookTile(
                                  book: data[index],
                                  height: devHeight,
                                );
                              },
                            ),
                          ),
                        );
                },
                loading: () => const Loader(),
                error: (error, stack) {
                  return const ErrorText(error: "Some error occurred");
                })
          ],
        ));
  }
}
