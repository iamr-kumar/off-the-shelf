import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final IconData leading;
  final bool isLogout;
  final VoidCallback onTap;
  const ProfileListTile(
      {super.key,
      required this.title,
      required this.leading,
      this.isLogout = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      tileColor: Pallete.blueGrey,
      leading: Icon(
        leading,
        color: isLogout ? Pallete.red : Pallete.primaryBlue,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Pallete.red : Pallete.primaryBlue,
        ),
      ),
      trailing: Icon(
        FeatherIcons.chevronRight,
        color: isLogout ? Pallete.red : Pallete.primaryBlue,
      ),
      onTap: onTap,
    );
  }
}
