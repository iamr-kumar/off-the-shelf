import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:off_the_shelf/src/core/constants/local_constants.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/features/library/controller/book_search_controller.dart';
import 'package:off_the_shelf/src/features/library/view/book_search_modal.dart';
import 'package:off_the_shelf/src/features/onboarding/view/set_target_screen.dart';
import 'package:off_the_shelf/src/models/book.model.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class OnboardingBookSelectScreen extends ConsumerWidget {
  static const route = '/onboarding/select-book';
  const OnboardingBookSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    final Widget onboardingBookSearchIllustration = SvgPicture.asset(
        Constants.onboardingBookSearchIllustration,
        height: devHeight * 0.55);

    Book? selectedBook = ref.watch(bookSearchControllerProvider).selectedBook;

    void routeBack() {
      Navigator.of(context).pop();
    }

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
                isUpdate: false,
              ),
            );
          });
    }

    void nextPage() {
      Routemaster.of(context).push(OnboardingSetTargetScreen.route);
    }

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8, bottom: 16.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: routeBack,
              child: const Icon(
                FeatherIcons.chevronLeft,
                color: Pallete.primaryBlue,
              ),
            ),
            onboardingBookSearchIllustration,
            const Text(
              'Add a book',
              style: AppStyles.headingTwo,
            ),
            selectedBook == null
                ? const Text(
                    'Search for a book that you are currently reading or planning to read',
                    style: AppStyles.subtext,
                  )
                : Text(
                    'You are currently set for a wonderful journey ahead with ${selectedBook.title}',
                    style: AppStyles.subtext,
                  ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          text: 'Find Book',
                          onPressed: () => searchBook(context)),
                    ),
                    Visibility(
                      visible: selectedBook != null,
                      child: const SizedBox(
                        width: 16,
                      ),
                    ),
                    Visibility(
                      visible: selectedBook != null,
                      child: InkWell(
                        onTap: nextPage,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Pallete.primaryBlue),
                          child: const Icon(
                            FeatherIcons.arrowRight,
                            color: Pallete.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
