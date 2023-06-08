import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/show_goal_dialog.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/custom_app_bar.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/controller/user_controller.dart';
import 'package:off_the_shelf/src/features/user/widgets/account_list_tile.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static const route = '/account';

  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late TextEditingController _targetController;

  int type = 0;

  @override
  void initState() {
    super.initState();
    _targetController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _targetController.dispose();
  }

  void updateType(int? value) {
    if (value != null) {
      setState(() {
        type = value;
      });
    }
  }

  void updateTarget(String text) {
    int? pages;
    int? minutes;
    if (type == 0) {
      pages = int.parse(text);
    } else {
      minutes = int.parse(text);
    }

    ref.read(userControllerProvider).updateUserGoal(
        context: context, pages: pages, minutes: minutes, type: type);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final goalType = user.goalType;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CustomAppBar(title: 'My Account'),
            const SizedBox(height: 20),
            AccountListTile(
              title: 'Current Goal',
              subtitle: goalType == GoalType.minutes
                  ? '${user.minutes} minutes/day'
                  : '${user.pages} pages/day',
              leading: FeatherIcons.activity,
              onTap: () async {
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
              },
            )
          ],
        ),
      )),
    );
  }
}
