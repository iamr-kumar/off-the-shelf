import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:off_the_shelf/src/core/constants/local_constants.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/features/onboarding/controller/onboarding_controller.dart';
import 'package:off_the_shelf/src/features/onboarding/view/finish_screen.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class OnboardingSetReminderScreen extends ConsumerWidget {
  static const route = '/onboarding/set-reminder';
  const OnboardingSetReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;

    final Widget onboardingTimeSelectIllustration = SvgPicture.asset(
        Constants.onboardingTimeSelectIllustration,
        height: devHeight * 0.6);

    void routeBack() {
      Navigator.pop(context);
    }

    final readingTime = ref.watch(onboardingControllerProvider).time;

    TimeOfDay initialTime = const TimeOfDay(hour: 17, minute: 0);

    void handleTimeSelect() async {
      TimeOfDay? newTime =
          await showTimePicker(context: context, initialTime: initialTime);

      if (newTime != null) {
        ref.read(onboardingControllerProvider.notifier).setTime(newTime);
      }
    }

    String getSubtext() {
      if (readingTime != null) {
        return 'You will be reminded to read everyday at ${readingTime.format(context)}';
      } else {
        return 'Tell us when you want to be reminded to read in a day';
      }
    }

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
            onboardingTimeSelectIllustration,
            const Text(
              'Select reading time',
              style: AppStyles.headingTwo,
            ),
            Text(getSubtext(), style: AppStyles.subtext),
            SizedBox(
              height: devHeight * 0.02,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Select Time',
                        onPressed: handleTimeSelect,
                      ),
                    ),
                    Visibility(
                      visible: readingTime != null,
                      child: const SizedBox(
                        width: 16,
                      ),
                    ),
                    Visibility(
                      visible: readingTime != null,
                      child: InkWell(
                        onTap: () {
                          Routemaster.of(context)
                              .push(OnboardingFinishScreen.route);
                        },
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
      )),
    );
  }
}
