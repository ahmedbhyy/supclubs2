import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonAuth extends StatelessWidget {
  final String mytitle;
  final void Function()? myfunction;
  const ButtonAuth(
      {super.key, required this.mytitle, required this.myfunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        padding: const EdgeInsets.all(7),
        color: const Color.fromARGB(255, 3, 56, 135),
        onPressed: myfunction,
        elevation: 6,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue[400]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          mytitle,
          style: GoogleFonts.mulish(
            fontSize: 20,
            color: const Color.fromARGB(205, 255, 119, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
