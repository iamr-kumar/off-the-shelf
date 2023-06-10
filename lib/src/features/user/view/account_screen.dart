import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/core/utils/show_goal_dialog.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/custom_app_bar.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/features/user/controller/user_controller.dart';
import 'package:off_the_shelf/src/features/user/widgets/account_list_tile.dart';
import 'package:off_the_shelf/src/providers/notification_service_provider.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class AccountScreen extends ConsumerStatefulWidget {
  static const route = '/account';

  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late TextEditingController _targetController;

  int type = 0;

  TimeOfDay initialTime = const TimeOfDay(hour: 17, minute: 0);

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

  void updateNotification(bool value) {
    ref
        .read(userControllerProvider)
        .updateNotification(context: context, notificationOn: value);
    ref.read(notificationServiceProvider).cancelAllReminders();
    setState(() {});
  }

  void handleTimeSelect(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (context.mounted && newTime != null) {
      ref.read(userControllerProvider).updateNotification(
            context: context,
            time: newTime,
          );

      ref
          .read(notificationServiceProvider)
          .cancelAndRescheduleReminder(newTime);

      setState(() {});
    }
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
            const CustomAppBar(title: 'Settings'),
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
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              tileColor: Pallete.blueGrey,
              leading:
                  const Icon(FeatherIcons.bell, color: Pallete.primaryBlue),
              title: const Text(
                'Allow Reminder',
                style: TextStyle(color: Pallete.primaryBlue),
              ),
              trailing: Switch.adaptive(
                value: ref.watch(userProvider)!.notificationOn!,
                onChanged: (value) => updateNotification(value),
              ),
            ),
            const SizedBox(height: 20),
            AccountListTile(
                title: 'Reminder At',
                subtitle: user.notifyAt == null
                    ? 'Not set'
                    : user.notifyAt!.format(context),
                leading: FeatherIcons.clock,
                onTap: () => handleTimeSelect(context)),
          ],
        ),
      )),
    );
  }
}
