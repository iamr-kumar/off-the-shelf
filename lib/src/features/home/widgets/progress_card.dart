import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/progress_message.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/session/controller/session_controller.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    final readingGoal =
        user.goalType! == GoalType.pages ? user.pages : user.minutes;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Pallete.primaryBlue),
        child: ref.watch(todaysProgressProvider).when(
            data: (data) {
              int minutes = 0;
              int pages = 0;
              for (var log in data) {
                minutes += log.minutes;
                pages += log.pages;
              }
              final goal = user.goalType! == GoalType.minutes ? minutes : pages;
              final percentComplete = (goal / readingGoal!) * 100;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getProgressMessage(percentComplete),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Pallete.white,
                                fontWeight: FontWeight.w600)),
                        Text(
                            getStatusMessage(user.goalType!, user.pages!,
                                user.minutes!, pages, minutes),
                            style: AppStyles.bodyText
                                .copyWith(color: Colors.white60))
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(fit: StackFit.expand, children: [
                        CircularProgressIndicator(
                          value: percentComplete,
                          valueColor: const AlwaysStoppedAnimation(
                              Pallete.textGreyLight),
                          strokeWidth: 12,
                          backgroundColor: Pallete.primaryBlueOpaque,
                        ),
                        Center(
                            child: Text(
                                '${percentComplete.toStringAsFixed(0)}%',
                                style: AppStyles.bodyText
                                    .copyWith(color: Pallete.white))),
                      ])),
                ],
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(
                  color: Pallete.white,
                )));
  }
}
