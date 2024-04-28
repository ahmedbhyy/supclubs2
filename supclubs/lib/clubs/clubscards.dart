import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:supclubs/widgets/slides/slide_right.dart';

class ClubsCard extends StatelessWidget {
  final String title;
  final String source;
  final Widget child;

  const ClubsCard({
    Key? key,
    required this.title,
    required this.source,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SlideRight(page: child));
      },
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.elliptical(20, 20),
          ),
          side: BorderSide(
            color: Color.fromARGB(255, 169, 142, 187),
            width: 2.0,
          ),
        ),
        shadowColor: Colors.grey[800],
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.elliptical(20, 20),
          ),
          child: Image.asset(
            source,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              } else {
                return Lottie.asset(
                  "images/lottie_loading2.json",
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
