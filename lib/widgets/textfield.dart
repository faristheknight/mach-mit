import 'package:flutter/material.dart';
import 'package:mach_mit/constants.dart';

class MyTextField extends StatefulWidget {
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int lines;
  final String hinttext;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  const MyTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    required this.lines,
    required this.hinttext,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: text_color1),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: text_color2)
            : null,
        suffixIcon: widget.suffixIcon != null
            ? Icon(widget.suffixIcon, color: text_color2)
            : null,
        hintText: widget.hinttext,
        hintStyle: TextStyle(color: text_color2),
        filled: true,
        fillColor: searchbar_color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cursorWidth: 1.0,
      cursorHeight: 25.0,
      cursorOpacityAnimates: true,
      cursorColor: text_color2,
      minLines: widget.lines,
      maxLines: widget.obscureText ? 1 : 10,
    );
  }
}
