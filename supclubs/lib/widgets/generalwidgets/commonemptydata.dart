import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyData extends StatelessWidget {
  final String text;
  final double padd;
  const EmptyData({super.key, required this.text, required this.padd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / padd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue[800],
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset("images/lottie_empty.json", height: 80),
        ],
      ),
    );
  }
}
