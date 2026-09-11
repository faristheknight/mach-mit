
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color selectedColor;
  final double width;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.selectedColor,
    required this.width
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      
      color: selected ? widget.selectedColor : widget.color,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
         onTap: () {
          setState(() {
            selected = true; // oder !selected zum Umschalten
          });
          widget.onTap();
        },
        child: Container(
          width: widget.width,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),

          ),
        ),
      ),
    );
  }
}