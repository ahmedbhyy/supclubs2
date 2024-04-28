import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';

class AboutUs extends StatefulWidget {
  final double appvote;
  final String userid;
  const AboutUs({super.key, required this.appvote, required this.userid});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        children: [
          const AppBarProfil(
            title: "About Us",
            lottie: "images/lottie_info.json",
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "images/ourlogo2.png",
              fit: BoxFit.fill,
              height: 300,
            ),
          ),
          Center(
            child: RatingBar.builder(
              initialRating: widget.appvote,
              minRating: 1.0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rate_sharp,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                AwesomeDialog(
                  context: context,
                  title: "Sup'Clubs",
                  dismissOnTouchOutside: false,
                  titleTextStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  btnOkColor: Colors.blue[500],
                  desc: "Your vote is appreciated! \u2665",
                  dialogType: DialogType.success,
                  animType: AnimType.rightSlide,
                  btnOkOnPress: () async {
                    await saveuserVote(rating);
                  },
                ).show();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Text(
              "Explore a dynamic calendar packed with club events, from social mixers to skill-building workshops. Dive into a diverse array of workshops tailored to your interests and academic pursuits.",
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                color: Colors.blue[800],
              ),
            ),
          ),
          Lottie.asset(
            "images/lottie_animation4.json",
            height: 110,
          )
        ],
      ),
    );
  }

  Future<void> saveuserVote(double vote) async {
    try {
      await _firestore.collection('users').doc(widget.userid).set({
        'appvote': vote,
      }, SetOptions(merge: true));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Please Try again!"),
        ),
      );
    }
  }
}
