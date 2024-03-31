import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/same_text_semester.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopDetail extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String place;
  final String myurl;
  final int membersnumber;
  final String clubname;
  final String workshopid;
  final double workshopvote;

  const WorkshopDetail({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.place,
    required this.myurl,
    required this.workshopvote,
    required this.workshopid,
    required this.clubname,
    required this.membersnumber,
  });

  @override
  State<WorkshopDetail> createState() => _WorkshopDetailState();
}

class _WorkshopDetailState extends State<WorkshopDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
        children: [
          AppBarProfil(
            title: widget.title,
            lottie: "images/lottie_pdf.json",
          ),
          Lottie.asset("images/lottie_workshop.json", height: 300),
          const SameTextSemester(
            title: "* Workshop Title :",
          ),
          Text(
            "   ${widget.title}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SameTextSemester(
            title: "* Workshop date :",
          ),
          Text(
            "   ${widget.date}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SameTextSemester(
            title: "* Workshop Time :",
          ),
          Text(
            "   ${widget.time}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SameTextSemester(
            title: "* Workshop Place :",
          ),
          Text(
            "   ${widget.place}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SameTextSemester(
                title: "* Rate ${widget.title}",
              ),
              RatingBar.builder(
                initialRating: widget.workshopvote / widget.membersnumber,
                minRating: 1.0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rate_sharp,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  AwesomeDialog(
                    context: context,
                    title: "${widget.title}",
                    dismissOnTouchOutside: false,
                    titleTextStyle: TextStyle(
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
                      await saveworkshopvote(rating);
                    },
                  ).show();
                },
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          ButtonAuth(
            mytitle: "Download PDF",
            myfunction: () async {
              await launchUrling();
            },
          )
        ],
      ),
    );
  }

  Future<void> saveworkshopvote(double vote) async {
    try {
      await _firestore
          .collection('${widget.clubname}workshops')
          .doc(widget.workshopid)
          .set({
        'vote': vote + widget.workshopvote,
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

  Future<void> launchUrling() async {
    if (!await launchUrl(Uri.parse(widget.myurl))) {
      throw Exception('Could not launch ${widget.myurl}');
    }
  }
}
