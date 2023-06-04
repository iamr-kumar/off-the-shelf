import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/features/library/controller/book_search_controller.dart';
import 'package:off_the_shelf/src/features/library/widgets/book_tile.dart';
import 'package:off_the_shelf/src/features/onboarding/controller/onboarding_controller.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class OnboardingFinishScreen extends ConsumerWidget {
  static const route = '/onboarding/finish';
  const OnboardingFinishScreen({super.key});

  void completeOnboarding(WidgetRef ref, BuildContext context) async {
    ref.read(onboardingControllerProvider.notifier).completeOnboarding(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    void routeBack() {
      Navigator.pop(context);
    }

    final selectedBook = ref.watch(bookSearchControllerProvider).selectedBook;

    final data = ref.watch(onboardingControllerProvider);

    final isLoading = data.loading;

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8, bottom: 16.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: devHeight * 0.02,
            ),
            InkWell(
              onTap: routeBack,
              child: const Icon(
                FeatherIcons.chevronLeft,
                color: Pallete.primaryBlue,
              ),
            ),
            SizedBox(
              height: devHeight * 0.01,
            ),
            const Text('Let\'s finish up', style: AppStyles.headingTwo),
            SizedBox(
              height: devHeight * 0.02,
            ),
            Text('You\'re set to read',
                style: AppStyles.bodyText.copyWith(color: Pallete.textGrey)),
            SizedBox(
              height: devHeight * 0.02,
            ),
            Align(
                alignment: Alignment.center,
                child: BookTile(book: selectedBook!, height: devHeight)),
            SizedBox(
              height: devHeight * 0.02,
            ),
            const Text('Your target is', style: AppStyles.bodyText),
            SizedBox(
              height: devHeight * 0.01,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      data.pages != null
                          ? '${data.pages} pages'
                          : '${data.minutes} minutes',
                      style: AppStyles.subheading.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Pallete.primaryBlue)),
                  const Text('per day', style: AppStyles.bodyText),
                ],
              ),
            ),
            SizedBox(
              height: devHeight * 0.02,
            ),
            const Text('You\'ll be notified at', style: AppStyles.bodyText),
            SizedBox(
              height: devHeight * 0.01,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(data.time!.format(context),
                      style: AppStyles.subheading.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Pallete.primaryBlue)),
                  const Text('every day', style: AppStyles.bodyText),
                ],
              ),
            ),
            SizedBox(
              height: devHeight * 0.06,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        isLoading: isLoading,
                        isDisabled: isLoading,
                        text: 'Finish',
                        onPressed: () => completeOnboarding(ref, context))))
          ],
        ),
      ),
    ));
  }
}
