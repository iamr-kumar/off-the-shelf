import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void showErrorSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(
      content: Text("Some error occurred"),
      backgroundColor: Pallete.red,
    ));
}
