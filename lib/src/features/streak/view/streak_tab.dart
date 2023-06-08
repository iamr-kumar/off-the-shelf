import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/features/streak/view/calendar_view.dart';
import 'package:off_the_shelf/src/features/streak/widgets/streak_card.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class StreakTab extends ConsumerWidget {
  const StreakTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devHeight = MediaQuery.of(context).size.height;
    final user = ref.watch(userProvider)!;

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CalendarView(),
                    SizedBox(height: devHeight * 0.05),
                    const Text(
                      'Streak',
                      style: AppStyles.headingThree,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: StreakCard(
                          streak: user.currentStreak.toString(),
                          title: 'Current',
                        )),
                        Expanded(
                            child: StreakCard(
                                streak: user.longestStreak.toString(),
                                title: 'Longest'))
                      ],
                    )
                  ],
                ))));
  }
}
