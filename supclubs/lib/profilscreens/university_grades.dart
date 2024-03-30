import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:supclubs/tab_bar_view/tab_bar_view_grades/tab_bar_view_semester1.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view_grades/tab_bar_view_semester2.dart';

class GradesUniversity extends StatefulWidget {
  final String useryear;
  const GradesUniversity({super.key, required this.useryear});

  @override
  State<GradesUniversity> createState() => _GradesUniversityState();
}

class _GradesUniversityState extends State<GradesUniversity> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldkey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blue, size: 28),
          surfaceTintColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 27,
              color: Color.fromARGB(255, 83, 137, 230),
            ),
          ),
          title: DefaultTextStyle(
            style: GoogleFonts.abel(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 28,
              color: Colors.blue[600],
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Grades"),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
            ),
          ),
          actions: [
            Lottie.asset(
              "images/lottie_supcom1.json",
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(
                child: Text("Semester 1"),
              ),
              Tab(
                child: Text("Semester 2"),
              ),
            ],
            unselectedLabelColor: const Color.fromARGB(255, 15, 193, 148),
            labelStyle: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colors.blue[700]),
          ),
        ),
        body: TabBarView(
          children: [
            TabBarSemesterOne(
              classe: widget.useryear,
            ),
            TabBarSemesterTwo(useryear: widget.useryear),
          ],
        ),
      ),
    );
  }
}
