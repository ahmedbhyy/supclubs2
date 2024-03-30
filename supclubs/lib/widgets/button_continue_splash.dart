import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supclubs/controller/onboarding_controller.dart';

class CustomButtonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomButtonOnBoarding({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 40,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 0),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        elevation: 7,
        onPressed: () {
          controller.next();
        },
        color: const Color.fromARGB(255, 49, 95, 175),
        child: Text(
          "Continue",
          style: GoogleFonts.aladin(
              fontSize: 23,
              fontStyle: FontStyle.italic,
              color: const Color.fromARGB(255, 228, 170, 11)),
        ),
      ),
    );
  }
}
