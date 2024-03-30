import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';

class NotificationDetails extends StatelessWidget {
  final String title;
  final String description;
  final String place;
  final String time;
  final String date;
  final String image;
  final String titleworkshop;

  const NotificationDetails({
    super.key,
    required this.title,
    required this.description,
    required this.place,
    required this.time,
    required this.date,
    required this.image,
    required this.titleworkshop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          AppBarProfil(
            title: title,
            lottie: "images/lottie_info.json",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 250,
                fit: BoxFit.fill,
                placeholder: (context, url) => Lottie.asset(
                  "images/lottie_loading2.json",
                  width: 100,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.elliptical(20, 20),
                ),
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.lightBlue),
                ),
                color: const Color.fromARGB(121, 8, 174, 169),
              ),
              width: double.maxFinite,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          titleworkshop,
                          style: GoogleFonts.abel(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: const Color.fromARGB(255, 4, 63, 135),
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Lottie.asset("images/lottie_location.json"),
                            Text(
                              place,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 40, 9, 216)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 232, 231, 240),
                          ),
                        ),
                        Text(
                          '$date, $time',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(255, 123, 30, 229),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 39, 58, 62),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
