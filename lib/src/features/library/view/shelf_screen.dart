import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/custom_app_bar.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/library/controller/library_controller.dart';
import 'package:off_the_shelf/src/features/library/widgets/book_tile.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:routemaster/routemaster.dart';

class ShelfScreen extends ConsumerWidget {
  static const route = '/shelf/:shelfType';
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeData = RouteData.of(context);
    final shelfType = routeData.pathParameters['shelfType'];
    final shelf = getStatusFromRouteParam(shelfType!);

    final devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
          child: Column(children: [
            CustomAppBar(title: describeStatusEnum(shelf)),
            const SizedBox(
              height: 20,
            ),
            ref.watch(booksByStatusProvider(shelf)).when(
                data: (books) {
                  return books.isEmpty
                      ? const Text('No books found', style: AppStyles.subtext)
                      : Expanded(
                          child: SizedBox(
                            height: devHeight * 0.3,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                return BookTile(
                                  book: books[index],
                                  height: devHeight,
                                  showLastRead: shelf != BookStatus.toRead,
                                );
                              },
                            ),
                          ),
                        );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader())
          ]),
        ),
      ),
    );
  }
}
