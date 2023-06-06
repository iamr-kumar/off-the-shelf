import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    void routeBack() {
      Routemaster.of(context).pop();
    }

    return Row(
      children: [
        InkWell(
          onTap: routeBack,
          child: const Icon(
            FeatherIcons.chevronLeft,
            color: Pallete.primaryBlue,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: AppStyles.headingFour,
        )
      ],
    );
  }
}
