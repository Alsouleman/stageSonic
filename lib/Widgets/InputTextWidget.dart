import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  const InputTextWidget({Key? key, required this.controller, this.iconData, this.assetsRefrence, required this.lableString, required this.isObscure}) : super(key: key);
  final TextEditingController controller;
  final IconData? iconData;
  final String? assetsRefrence ;
  final String lableString;
  final bool   isObscure;



  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: lableString,

        prefixIcon: iconData!= null
            ? Icon(iconData)
            :  const Padding(
                  padding:  EdgeInsets.all(8),

        ),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.grey,
            )
        ),
      ),
      obscureText:  isObscure,
    );
  }
}
