import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class myChats extends StatefulWidget{
  const myChats({super.key});


  @override
  State<myChats> createState() => _myChats();
}

class _myChats extends State<myChats>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Coming Soon', style: GoogleFonts.fraunces(fontSize: 
          24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}