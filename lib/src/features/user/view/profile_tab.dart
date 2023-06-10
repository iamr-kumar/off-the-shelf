import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/view/account_screen.dart';
import 'package:off_the_shelf/src/features/user/view/settings_modal.dart';
import 'package:off_the_shelf/src/features/user/widgets/profile_list_tile.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void showSettingsModal(BuildContext context, double devHeight) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        isScrollControlled: true,
        builder: (ctx) {
          return SizedBox(
            height: devHeight * 0.7,
            child: const SettingsModal(),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    // final devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          user.photoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(user.photoUrl!),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ))
              : CircleAvatar(
                  backgroundColor: Pallete.primaryBlue,
                  minRadius: 50,
                  child: Text(
                    user.name[0] + user.name.split(' ')[1][0],
                    style: const TextStyle(color: Pallete.white),
                  ),
                ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
                color: Pallete.primaryBlue,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ProfileListTile(
              title: 'Settings',
              leading: FeatherIcons.user,
              onTap: () => Routemaster.of(context).push(AccountScreen.route)),
          const SizedBox(height: 16),
          // ProfileListTile(
          //     title: 'Settings',
          //     leading: FeatherIcons.settings,
          //     onTap: () => showSettingsModal(context, devHeight)),
          const SizedBox(height: 16),
          ProfileListTile(
              title: 'Log Out',
              leading: FeatherIcons.logOut,
              onTap: () => logout(ref),
              isLogout: true),
          const SizedBox(height: 16),
        ],
      ),
    )));
  }
}
