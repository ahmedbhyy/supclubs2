import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supclubs/controller/onboarding_controller.dart';
import 'package:supclubs/widgets/button_continue_splash.dart';
import 'package:supclubs/widgets/customslider.dart';
import 'package:supclubs/widgets/dotcontroller.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp());
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: CustomSliderOnBoarding(),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  CustomDotControllerOnBoarding(),
                  Spacer(flex: 1),
                  CustomButtonOnBoarding(),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
