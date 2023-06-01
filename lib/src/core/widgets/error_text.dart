import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error, style: AppStyles.errorText),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ErrorText(
        error: error,
      )),
    );
  }
}
