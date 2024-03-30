import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircleSupcom extends StatelessWidget {
  final String lottie;

  const CircleSupcom({
    super.key,
    required this.lottie,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: const Color.fromARGB(255, 154, 107, 207),
      child: Lottie.asset(lottie),
    );
  }
}
