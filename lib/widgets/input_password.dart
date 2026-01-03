import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputPassword extends StatefulWidget {
  final TextEditingController controller;
  Widget? placeholder;
  Icon? prefixIcon;
  String? errorText;
  InputPassword({
    Key? key,
    required this.controller,
    this.placeholder,
    this.prefixIcon,
    this.errorText,
  }) : super(key: key);

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorHeight: 20,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white, fontSize: 12),
      obscureText: isObscure,
      validator: (value) {
        if(value!.isEmpty || value.length < 8){
          return widget.errorText;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hint: widget.placeholder,
        prefixIcon: widget.prefixIcon,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          child: isObscure
              ? Icon(Icons.visibility, color: Colors.white)
              : Icon(Icons.visibility_off, color: Colors.white),
        ),
        fillColor: Colors.white10,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue),
        ),
        isDense: true,
      ),
    );
  }
}
