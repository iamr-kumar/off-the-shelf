import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class Loader extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const Loader(
      {super.key, this.color = Pallete.primaryBlue, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color, strokeWidth: strokeWidth),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Loader(),
    ));
  }
}
