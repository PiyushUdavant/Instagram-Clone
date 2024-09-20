import'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final String hintText;
  
  const TextFieldInput({
    super.key , 
    required this.hintText , 
    this.isPass = false , 
    required this.textEditingController , 
    required this.textInputType
    }
  );
  
  @override
  Widget build(BuildContext context) { // context is passed here as an argument hence we need to use OutlineInputBorder method inside this widget only.
  // Also we can't put it in const TextFieldInput as methods can't be invoked in const expression. So , it's very important where you are placing a function or even the declarations.
    final inputBorder = OutlineInputBorder(
      borderSide:Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController, 
      decoration:InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8)
      ),
      keyboardType:textInputType,
      obscureText: isPass,
      
    );
  }
}