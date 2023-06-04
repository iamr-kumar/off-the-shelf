import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:off_the_shelf/src/core/constants/local_constants.dart';
import 'package:off_the_shelf/src/core/utils/show_goal_dialog.dart';
import 'package:off_the_shelf/src/core/widgets/custom_button.dart';
import 'package:off_the_shelf/src/features/onboarding/controller/onboarding_controller.dart';
import 'package:off_the_shelf/src/features/onboarding/view/set_reminder_screen.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class OnboardingSetTargetScreen extends ConsumerStatefulWidget {
  static const route = '/onboarding/set-target';
  const OnboardingSetTargetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingSetTargetScreenState();
}

class _OnboardingSetTargetScreenState
    extends ConsumerState<OnboardingSetTargetScreen> {
  int type = 1;

  final TextEditingController _targetController = TextEditingController();

  void setTargetType(int? value) {
    ref.read(onboardingControllerProvider.notifier).setType(value);
  }

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;

    final Widget onboardingSetTargetIllustration = SvgPicture.asset(
        Constants.onboardingSetTargetIllustration,
        height: devHeight * 0.6);

    final pages = ref.watch(onboardingControllerProvider).pages;

    final minutes = ref.watch(onboardingControllerProvider).minutes;

    void routeBack() {
      Navigator.pop(context);
    }

    void updateTarget(String text) {
      if (type == 1) {
        ref
            .read(onboardingControllerProvider.notifier)
            .setPages(int.parse(text));
      } else {
        ref
            .read(onboardingControllerProvider.notifier)
            .setMinutes(int.parse(text));
      }
      ref.read(onboardingControllerProvider.notifier).setType(type);
    }

    void updateType(int? value) {
      if (value != null) {
        setState(() {
          type = value;
        });
      }
    }

    String getSubtext() {
      if (pages != null) {
        return 'You have set your goal to read $pages pages per day';
      } else if (minutes != null) {
        return 'You have set your goal to read $minutes minutes per day';
      } else {
        return 'Tell us about your daily reading goals either in pages or minutes';
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
            onboardingSetTargetIllustration,
            const Text(
              'Set your goal',
              style: AppStyles.headingTwo,
            ),
            Text(
              getSubtext(),
              style: AppStyles.subtext,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          text: 'Set Goal',
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return showGoalDialog(
                                      context: context,
                                      targetController: _targetController,
                                      type: type,
                                      updateType: updateType);
                                });

                            if (_targetController.text.isNotEmpty) {
                              updateTarget(_targetController.text);
                            }
                          }),
                    ),
                    Visibility(
                      visible: pages != null || minutes != null,
                      child: const SizedBox(
                        width: 16,
                      ),
                    ),
                    Visibility(
                      visible: pages != null || minutes != null,
                      child: InkWell(
                        onTap: () {
                          Routemaster.of(context)
                              .push(OnboardingSetReminderScreen.route);
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
      ),
    ));
  }
}
