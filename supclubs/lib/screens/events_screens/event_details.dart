import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/screens/events_screens/event_registraition_list.dart';
import 'package:supclubs/widgets/buttton_auth.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  final String title;
  final String description;
  final String currentuserid;
  final String userimage;
  final String place;
  final String time;
  final String date;
  final String image;
  final String eventurl;
  final String userid;
  final String username;
  final String useryear;
  final String isregister;
  final String eventid;
  const EventDetails(
      {super.key,
      required this.title,
      required this.description,
      required this.place,
      required this.time,
      required this.date,
      required this.image,
      required this.eventurl,
      required this.userid,
      required this.isregister,
      required this.username,
      required this.useryear,
      required this.currentuserid,
      required this.eventid,
      required this.userimage});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  DateTime time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isregister == "Yes"
          ? Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 11.0,
              ),
              child: ButtonAuth(
                  mytitle: widget.currentuserid == widget.userid
                      ? " See Registraitions "
                      : " Register for ${widget.title} ",
                  myfunction: () {
                    widget.currentuserid != widget.userid
                        ? AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            title: 'Registration Confirmation',
                            desc:
                                'If you confirm the registration, your name will be added to the ${widget.title} list.',
                            descTextStyle: const TextStyle(fontSize: 18),
                            btnCancelOnPress: () {},
                            btnOkText: "Confirm",
                            btnOkOnPress: () async {
                              await addregistraitionevent();
                            },
                          ).show()
                        : Navigator.of(context).push(
                            SlideRight(
                              page: MembersEvents(eventid: widget.eventid),
                            ),
                          );
                  }),
            )
          : Container(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          AppBarProfil(
            title: widget.title,
            lottie: "images/lottie_info.json",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                height: 300,
                fit: BoxFit.fill,
                placeholder: (context, url) => Lottie.asset(
                  "images/lottie_loading2.json",
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
                          widget.title,
                          style: GoogleFonts.qwigley(
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              color: const Color.fromARGB(255, 4, 63, 135),
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Lottie.asset("images/lottie_location.json",
                                height: 35),
                            Text(
                              widget.place,
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
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Color.fromARGB(255, 145, 120, 7),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchUrl();
                          },
                          child: Row(
                            children: [
                              const Text(
                                "See more",
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.facebook,
                                size: 35,
                                color: Colors.blue[700],
                              ),
                            ],
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
                      widget.description,
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(widget.eventurl))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error , Please try again later !"),
        ),
      );
    }
  }

  Future<void> addregistraitionevent() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('events').doc(widget.eventid);

      await userDocRef.collection('registraition').add({
        'username': widget.username,
        'date': time.toString(),
        'image': widget.userimage,
        'year': widget.useryear,
      });
      showDialoge(
          "Registration",
          "your name is added to the ${widget.title} list.",
          DialogType.success);
    } catch (e) {
      showDialoge("Error", "Please try again later.", DialogType.error);
    }
  }

  void showDialoge(String title, String desc, DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      titleTextStyle: const TextStyle(
        color: Color.fromARGB(255, 228, 170, 11),
        fontSize: 25,
      ),
      desc: desc,
      descTextStyle: const TextStyle(fontSize: 17),
      btnOkColor: Colors.blue[900],
      btnOkText: 'Okay',
      btnOkOnPress: () {},
    ).show();
  }
}
