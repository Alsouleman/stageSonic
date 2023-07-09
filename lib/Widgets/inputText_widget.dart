import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
   const InputTextWidget({Key? key, required this.controller, this.prefixIcon,this.label, required this.isObscure, this.style,this.keyboardType}) : super(key: key);
  final TextEditingController controller;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? label;
  final bool   isObscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style,
      controller: controller,
      decoration: InputDecoration(
        label: label,
        prefixIcon: prefixIcon,
        helperStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: Colors.transparent,
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(
              color: Colors.transparent,
            )
        ),
      ),
      obscureText:  isObscure,
      keyboardType: keyboardType,
    );
  }
}
