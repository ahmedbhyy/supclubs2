
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AppBarProfil extends StatelessWidget {
  final String title;
  final String lottie;
  const AppBarProfil({super.key, required this.title, required this.lottie});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      surfaceTintColor: Colors.white,
      leading: Navigator.canPop(context)
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 27,
                color: Color.fromARGB(255, 83, 137, 230),
              ),
            )
          : Container(),
      title: DefaultTextStyle(
          style: GoogleFonts.abel(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.blue,
          ),
          child: Text(
              title) ,
          ),
      actions: [
        Lottie.asset(lottie, repeat: false),
      ],
    );
  }
}
