import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isOutlined;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;
  final bool isCompact;

  const CustomButton(
      {Key? key,
      required this.text,
      this.isOutlined = false,
      this.isLoading = false,
      this.isDisabled = false,
      this.isCompact = false,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: isOutlined ? Colors.white : Pallete.primaryBlue,
          padding: isCompact
              ? const EdgeInsets.symmetric(horizontal: 30, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
          foregroundColor: isOutlined ? Pallete.primaryBlue : null,
          elevation: 4,
          side: isOutlined
              ? const BorderSide(color: Pallete.primaryBlue, width: 1.0)
              : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Stack(
        children: [
          Visibility(
            visible: isLoading ? false : true,
            child: Text(text,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w600)),
          ),
          Visibility(
              visible: isLoading,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Loader(
                  color: isOutlined ? Pallete.primaryBlue : Pallete.white,
                  strokeWidth: 2.5,
                ),
              ))
        ],
      ),
    );
  }
}
