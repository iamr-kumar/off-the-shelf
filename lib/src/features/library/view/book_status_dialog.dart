import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';

Widget showBookStatusDialog(
    {required BuildContext context,
    required int page,
    required TextEditingController progressController,
    required int status,
    required Function updateStatus,
    required VoidCallback onComplete,
    bool isUpdate = true}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    insetPadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    title: const Text('What\'s your progress?'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...BookStatus.values
            .map((val) => RadioListTile(
                  value: val.index,
                  groupValue: status,
                  onChanged: isUpdate
                      ? (val) => updateStatus(val as int)
                      : val.index <= 1
                          ? (val) => updateStatus(val as int)
                          : null,
                  title: Text(describeStatusEnum(val)),
                ))
            .toList(),
        status == 1
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: progressController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Page',
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              onComplete();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        )
      ],
    ),
  );
}
