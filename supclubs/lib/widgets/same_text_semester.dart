import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SameTextSemester extends StatelessWidget {
  final String title;
  const SameTextSemester({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: GoogleFonts.abel(
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}
