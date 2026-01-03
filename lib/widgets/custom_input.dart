import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  Widget? placeholder;
  Icon? prefixIcon;
  Widget? suffix;
  bool? readOnly;
  List<TextInputFormatter>? inputFormatters;
  String? errorText;
  CustomInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.prefixIcon,
    this.suffix,
    this.readOnly,
    this.inputFormatters,
    this.errorText
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      style: TextStyle(color: Colors.white,fontSize: 12),
      cursorHeight: 20,
      validator: (value) {
        if(value!.isEmpty){
          return widget.errorText;
        } else {
          return null;
        }
      },
      cursorColor: Colors.white,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffix,
        fillColor: Colors.white10,
        filled: true,
        hint: widget.placeholder,
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
