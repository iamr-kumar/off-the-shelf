import 'package:flutter/material.dart';

void showNewDialog(BuildContext context, Widget widget, bool dismissible) {
  showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      return widget;
    },
  );
}
