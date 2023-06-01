import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          color: Pallete.textGrey,
          thickness: 0.4,
        )),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: const Text(
            "or",
            style: TextStyle(
              color: Pallete.textGrey,
            ),
          ),
        ),
        const Expanded(
            child: Divider(
          color: Pallete.textGrey,
          thickness: 0.4,
        )),
      ],
    );
  }
}
