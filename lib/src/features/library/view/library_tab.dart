import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/library/view/book_search_modal.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    void searchBook(BuildContext context) {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          isDismissible: false,
          isScrollControlled: true,
          builder: (ctx) {
            return SizedBox(
              height: devHeight * 0.95,
              child: const BookSearch(
                isUpdate: true,
              ),
            );
          });
    }

    void navigateToShelf(BookStatus shelf) {
      Routemaster.of(context).push('/shelf/${shelf.name}');
    }

    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shelves', style: AppStyles.headingFour),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 2,
            color: Pallete.textGreyLight,
          ),
          ref.watch(allBooksProvider).when(
              data: (data) {
                Map<BookStatus, List<Book>> booksByStatus = {};
                for (final book in data) {
                  booksByStatus[book.status] = booksByStatus[book.status] ?? [];
                  booksByStatus[book.status]!.add(book);
                }
                return Column(
                  children: BookStatus.values.map((value) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(describeStatusEnum(value)),
                          leading: const Icon(
                            FeatherIcons.book,
                            color: Pallete.primaryBlue,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                booksByStatus[value]?.length.toString() ?? '0',
                                style: AppStyles.bodyText,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                FeatherIcons.chevronRight,
                                size: 24,
                                color: Pallete.primaryBlue,
                              )
                            ],
                          ),
                          onTap: () => navigateToShelf(value),
                        ),
                        Container(
                          height: 2,
                          color: Pallete.textGreyLight,
                        )
                      ],
                    );
                  }).toList(),
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const Loader()),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 200,
                child: CustomButton(
                    text: 'Add Book', onPressed: () => searchBook(context)),
              ),
            ),
          )
        ],
      ),
    )));
  }
}
