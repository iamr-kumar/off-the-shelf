import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class AccountListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leading;
  final VoidCallback onTap;
  const AccountListTile(
      {super.key,
      required this.title,
      required this.leading,
      required this.onTap,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      tileColor: Pallete.blueGrey,
      leading: Icon(
        leading,
        color: Pallete.primaryBlue,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Pallete.primaryBlue,
            ),
          ),
          Text(
            subtitle,
            style: AppStyles.subtext.copyWith(fontSize: 14),
          )
        ],
      ),
      trailing: const Icon(
        FeatherIcons.edit2,
        color: Pallete.primaryBlue,
      ),
      onTap: onTap,
    );
  }
}
