import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final TextInputType textInputType;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final String? initialValue;

  const InputField(
      {super.key,
      required this.textEditingController,
      this.textInputType = TextInputType.text,
      this.initialValue,
      this.isPassword = false,
      this.hintText = '',
      this.validator,
      this.icon});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      obscureText: _isObscure,
      controller: widget.textEditingController,
      validator: widget.validator,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Pallete.textGrey),
          labelStyle: const TextStyle(color: Pallete.textGrey),
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  color: Pallete.textGrey,
                )
              : null,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: Divider.createBorderSide(
                context,
                color: Pallete.textGrey,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Pallete.textGrey))),
    );
  }
}
