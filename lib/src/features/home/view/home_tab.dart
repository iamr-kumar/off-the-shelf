import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/handle_time.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/home/widgets/progress_card.dart';
import 'package:off_the_shelf/src/features/home/widgets/reading_section.dart';
import 'package:off_the_shelf/src/features/home/widgets/recently_completed.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    final greetingMessage = getGreetingMessage();

    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 24, bottom: 8, left: 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        user.photoUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.photoUrl!),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '$greetingMessage, ${user.name.split(' ').first} 👋',
                          style: AppStyles.bodyText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Pallete.primaryBlue),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceHeight * 0.035),
                    const ProgressCard(),
                    SizedBox(height: deviceHeight * 0.03),
                    const ReadingSection(),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    const RecentlyCompleted()
                  ]),
            ),
          ),
        ));
  }
}
