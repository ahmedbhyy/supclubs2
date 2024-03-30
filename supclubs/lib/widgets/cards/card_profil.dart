import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class CardProfil extends StatelessWidget {
  final String title;
  final String path;

  final Widget child;

  const CardProfil({
    super.key,
    required this.title,
    required this.path,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SlideRight(page: child));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        shadowColor: Colors.grey,
        elevation: 5,
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.abel(
                    fontSize: 19,
                    color: const Color.fromARGB(255, 78, 59, 3),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Lottie.asset(path, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
