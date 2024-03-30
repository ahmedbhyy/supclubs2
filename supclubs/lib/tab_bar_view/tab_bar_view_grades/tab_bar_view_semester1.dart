import 'package:flutter/material.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view_grades/indp1/indp1_semester1.dart';
import 'package:supclubs/tab_bar_view/tab_bar_view_grades/indp2/indp2_semester1.dart';

class TabBarSemesterOne extends StatefulWidget {
  final String classe;
  const TabBarSemesterOne({super.key, required this.classe});

  @override
  State<TabBarSemesterOne> createState() => _TabBarSemesterOneState();
}

class _TabBarSemesterOneState extends State<TabBarSemesterOne> {
 
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: scaffoldkey,
        child: widget.classe != 'INDP1'
            ? const IndpTwoSemOne()
            : const IndpOneSemOne(),
      ),
    );
  }
}
