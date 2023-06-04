import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class PercentProgressIndicator extends StatefulWidget {
  final double percent;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double width;
  final double borderRadius;

  const PercentProgressIndicator({
    super.key,
    required this.percent,
    this.backgroundColor = Pallete.textGreyLight,
    this.progressColor = Pallete.primaryBlue,
    this.height = 10,
    this.width = 200,
    this.borderRadius = 8,
  });

  @override
  State<PercentProgressIndicator> createState() =>
      _PercentProgressIndicatorState();
}

class _PercentProgressIndicatorState extends State<PercentProgressIndicator> {
  double _width = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _width = widget.percent * widget.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: _width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.progressColor),
        ),
      ],
    );
  }
}
