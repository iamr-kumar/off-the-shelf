import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class StreakCard extends StatelessWidget {
  final String streak;
  final String title;
  const StreakCard({super.key, required this.streak, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(streak, style: AppStyles.headingOne.copyWith(fontSize: 72)),
            Text(title, style: AppStyles.headingFive),
          ],
        ),
      ),
    );
  }
}
