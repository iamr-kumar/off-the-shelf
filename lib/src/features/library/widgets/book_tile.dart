// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/features/library/widgets/percent_progress_indicator.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final double height;

  const BookTile({
    Key? key,
    required this.book,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Text('by ${book.authors.join(',')}',
                        style: AppStyles.subtext),
                    const SizedBox(
                      height: 20,
                    ),
                    PercentProgressIndicator(
                      percent: book.progress / book.pageCount,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${book.progress} of ${book.pageCount} pages read',
                        style: AppStyles.bodyText.copyWith(fontSize: 14))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
