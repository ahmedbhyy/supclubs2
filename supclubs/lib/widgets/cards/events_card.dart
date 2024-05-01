import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class EventsCard extends StatelessWidget {
  final String title;
  final String date;
  final String? time;
  final String place;
  final String id;
  final String source;
  final Widget child;
  final Function() onLongPress;

  const EventsCard({
    Key? key,
    required this.title,
    required this.source,
    required this.child,
    required this.date,
    required this.place,
    this.time,
    required this.onLongPress,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: () {
        Navigator.of(context).push(SlideRight(page: child));
      },
      child: Card(
        color: Colors.blue[50],
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Lottie.asset("images/lottie_arrow.json", width: 30),
                ],
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    imageUrl: source,
                    width: 80,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Lottie.asset(
                      "images/lottie_loading2.json",
                      width: 100,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$time, $date",
                    style: const TextStyle(
                        fontSize: 11.5, fontStyle: FontStyle.italic),
                  ),
                  Row(
                    children: [
                      Lottie.asset("images/lottie_location.json", width: 16.0),
                      Text(
                        place,
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
