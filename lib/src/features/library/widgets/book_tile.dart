// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/handle_time.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/library/widgets/percent_progress_indicator.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class BookTile extends ConsumerWidget {
  final Book book;
  final double height;
  final bool showLastRead;

  const BookTile(
      {Key? key,
      required this.book,
      required this.height,
      this.showLastRead = true})
      : super(key: key);

  List<PopupMenuItem> getPopupMenuItems(BookStatus status) {
    switch (status) {
      case BookStatus.toRead:
        return [
          const PopupMenuItem(
            value: 'reading',
            child: Text('Move to reading'),
          )
        ];
      case BookStatus.reading:
        return [
          const PopupMenuItem(
            value: 'toRead',
            child: Text('Move to be read'),
          ),
          const PopupMenuItem(
            value: 'finished',
            child: Text('Move to finsihed'),
          ),
          const PopupMenuItem(
            value: 'abandoned',
            child: Text('Move to abandoned'),
          )
        ];
      case BookStatus.finished:
        return [
          const PopupMenuItem(
            value: 'toRead',
            child: Text('Move to re-read'),
          ),
          const PopupMenuItem(
            value: 'reading',
            child: Text('Move to reading'),
          )
        ];
      case BookStatus.abandoned:
        return [
          const PopupMenuItem(
            value: 'toRead',
            child: Text('Move to be read'),
          ),
          const PopupMenuItem(
            value: 'reading',
            child: Text('Move to reading'),
          )
        ];
      default:
        return [];
    }
  }

  void handleMovement(BuildContext context, String? value, WidgetRef ref) {
    if (value == null) return;
    BookStatus updatedStatus;
    switch (value) {
      case 'toRead':
        updatedStatus = BookStatus.toRead;
        break;
      case 'reading':
        updatedStatus = BookStatus.reading;
        break;
      case 'finished':
        updatedStatus = BookStatus.finished;
        break;
      case 'abandoned':
        updatedStatus = BookStatus.abandoned;
        break;
      default:
        updatedStatus = BookStatus.toRead;
    }
    ref
        .read(libraryControllerProvider)
        .updateBookStatus(context, book.id, updatedStatus);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shadowColor: Pallete.textGreyLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Pallete.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            book.thumbnail != null
                ? Image(
                    image: NetworkImage(book.thumbnail!),
                    height: height * 0.15,
                    width: 100,
                  )
                : const SizedBox(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        book.title.length > 50
                            ? '${book.title.substring(0, 50)}...'
                            : book.title,
                        style: AppStyles.headingFive),
                    Text(book.authors.join(','), style: AppStyles.subtext),
                    const SizedBox(
                      height: 10,
                    ),
                    PercentProgressIndicator(
                      percent: book.progress / book.pageCount,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${book.progress} of ${book.pageCount} pages read',
                        style: AppStyles.bodyText.copyWith(fontSize: 14)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      showLastRead
                          ? 'Last read ${formatDate(book.updatedAt!)}'
                          : 'Added on ${formatDate(book.createdAt!)}',
                      style: AppStyles.subtext.copyWith(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return getPopupMenuItems(book.status);
              },
              onSelected: (value) => handleMovement(context, value, ref),
            )
          ],
        ),
      ),
    );
  }
}
