import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingForData extends StatelessWidget {
  final double ver;
  final double hor;
  final double loadingsize;
  const LoadingForData(
      {super.key,
      required this.ver,
      required this.hor,
      required this.loadingsize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / ver,
        horizontal: MediaQuery.of(context).size.width / hor,
      ),
      child: LoadingAnimationWidget.inkDrop(
        color: Color.fromARGB(255, 85, 27, 231),
        size: loadingsize,
      ),
    );
  }
}
