import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/core/utils/snackbar.dart';

Widget showGoalDialog({
  required BuildContext context,
  required TextEditingController targetController,
  required int type,
  required Function updateType,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    // contentPadding: const EdgeInsets.all(0),
    insetPadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                  title: const Text('Pages'),
                  value: 0,
                  groupValue: type,
                  onChanged: (value) => updateType(value)),
            ),
            Expanded(
              child: RadioListTile(
                  title: const Text('Minutes'),
                  value: 1,
                  groupValue: type,
                  onChanged: (value) => updateType(value)),
            )
          ],
        ),
        TextFormField(
          controller: targetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter your goal"),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              if (targetController.text.isEmpty) {
                showSnackBar(context, 'Please enter a goal');
                return;
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ),
      ],
    ),
  );
}
