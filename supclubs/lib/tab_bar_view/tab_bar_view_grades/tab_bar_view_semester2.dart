import 'package:flutter/material.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view_grades/indp1/indp1_semester2.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view_grades/indp2/indp2_semester2.dart';

class TabBarSemesterTwo extends StatefulWidget {
  final String useryear;
  const TabBarSemesterTwo({super.key, required this.useryear});

  @override
  State<TabBarSemesterTwo> createState() => _TabBarSemesterTwoState();
}

class _TabBarSemesterTwoState extends State<TabBarSemesterTwo> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: scaffoldkey,
        child: widget.useryear != 'INDP1'
            ? const IndpTwoSemTwo()
            : const IndpOneSemTwo(),
      ),
    );
  }
}
