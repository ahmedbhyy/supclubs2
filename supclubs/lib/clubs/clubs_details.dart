import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/clubs/club_members.dart';
import 'package:supclubs/clubs/club_roadmap.dart';
import 'package:supclubs/clubs/club_workshops.dart';
import 'package:supclubs/clubs/clubs_bureau.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubsDetails extends StatefulWidget {
  final String name;

  final String imagepath3;
  final String clubid;

  final String clubiduser;
  final String username;
  final String userid;
  final String useryear;
  final String useremail;
  final Uri urlfb;
  final Uri urlinstagram;
  final List bureauimages;
  final List bureauleaders;

  final String description;
  const ClubsDetails({
    super.key,
    required this.name,
    required this.imagepath3,
    required this.description,
    required this.urlfb,
    required this.urlinstagram,
    required this.clubid,
    required this.username,
    required this.userid,
    required this.useryear,
    required this.useremail,
    required this.clubiduser,
    required this.bureauimages,
    required this.bureauleaders,
  });

  @override
  State<ClubsDetails> createState() => _ClubsDetailsState();
}

class _ClubsDetailsState extends State<ClubsDetails>
    with TickerProviderStateMixin {
  bool _isFavorited = false;
  Uri ieeeurl = Uri.parse(
      "https://supcom.ieee.tn/?fbclid=IwAR3ACDt2WLl46A8Bg9xjZEhPnA1_MyVHHD0_HmosWsBImaWwX2QFV7yTnQI");

  String _imageFile = '';

  List<QueryDocumentSnapshot> data1 = [];
  getData2() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('invitation')
        .where('idsender', isEqualTo: widget.userid)
        .where('clubid', isEqualTo: widget.clubid)
        .get();

    data1.addAll(querySnapshot.docs);
    setState(() {});
  }

  List<QueryDocumentSnapshot> data = [];

  Future<void> getData() async {
    try {
      DocumentReference clubDocument =
          FirebaseFirestore.instance.collection('clubs').doc(widget.clubid);

      QuerySnapshot membersSnapshot =
          await clubDocument.collection('members').get();

      data.addAll(membersSnapshot.docs);

      setState(() {});
    } catch (e) {
      return;
    }
  }

  void fetchProfileImage() {
    final store = FirebaseStorage.instance.ref();
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;
    final pdpref = store.child("profil/$newprofilpic.jpg");
    try {
      pdpref.getDownloadURL().then((value) {
        setState(() {
          _imageFile = value;
        });
      }, onError: (val) {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue lors de l'importation du l'image veuillez réessayer ultérieurement")));
    }
  }

  late AnimationController _favoriteController;

  @override
  void initState() {
    getData();
    getData2();
    fetchProfileImage();

    _favoriteController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _favoriteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isInList = isCurrentUserInList(widget.userid);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Capture.PNG"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 29,
                          color: Color.fromARGB(255, 1, 62, 167),
                        ),
                      ),
                      widget.clubiduser != widget.clubid
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 36, 140, 177),
                              radius: 25.0,
                              child: isInList
                                  ? InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          title: "Already a Member",
                                          desc:
                                              "You are already a member,  you have access to ${widget.name} Workshops",
                                          dialogType: DialogType.info,
                                          animType: AnimType.rightSlide,
                                          btnOkOnPress: () {},
                                        ).show();
                                      },
                                      child: Lottie.asset(
                                          "images/lottie_icon2.json"),
                                    )
                                  : data1.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.rightSlide,
                                              title: 'Invitation',
                                              titleTextStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 25,
                                              ),
                                              desc:
                                                  'Your invitation was send to ${widget.name} admin. Please wait the confirmation ',
                                              descTextStyle:
                                                  const TextStyle(fontSize: 18),
                                              btnOkOnPress: () {},
                                            ).show();
                                          },
                                          child: Lottie.asset(
                                              "images/lottie_icon2.json"),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            if (_favoriteController.status ==
                                                AnimationStatus.dismissed) {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.rightSlide,
                                                btnOkText: "Send",
                                                body: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Join ${widget.name}',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blue[800],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Image.asset(
                                                          widget.imagepath3,
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                          "Before you can access ${widget.name}, we kindly ask you to wait for confirmation from the club administrator. Once approved, you will have full access to the workshops and the chat club."),
                                                    )
                                                  ],
                                                ),
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () async {
                                                  await addInvitationToFirestore(
                                                    widget.clubid,
                                                    widget.useremail,
                                                    widget.useryear,
                                                    widget.userid,
                                                    widget.username,
                                                    DateTime.now().toString(),
                                                    widget.name,
                                                    _imageFile,
                                                  );
                                                  _favoriteController.reset();
                                                  _favoriteController
                                                      .animateTo(1);
                                                },
                                              ).show();
                                            } else {
                                              _favoriteController.reverse();
                                            }
                                            setState(() =>
                                                _isFavorited = !_isFavorited);
                                          },
                                          icon: Lottie.asset(
                                              "images/lottie_icon2.json",
                                              controller: _favoriteController),
                                        ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Image.asset(
                  widget.imagepath3,
                  width: 150,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(124, 1, 150, 125),
                    ),
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  DefaultTextStyle(
                                    style: GoogleFonts.qwigley(
                                      fontSize: 40,
                                      fontStyle: FontStyle.italic,
                                      color: const Color.fromARGB(
                                          255, 222, 222, 60),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        WavyAnimatedText(widget.name),
                                      ],
                                      isRepeatingAnimation: false,
                                      displayFullTextOnTap: true,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Lottie.asset(
                                          "images/lottie_location.json"),
                                      const Text(
                                        "Sup'Com",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            color: Color.fromARGB(
                                                255, 191, 226, 32)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    SlideRight(
                                      page: ClubMembers(
                                        clubname: widget.name,
                                        clubid: widget.clubid,
                                        clubiduser: widget.clubiduser,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Lottie.asset("images/lottie_icon2.json",
                                        height: 55),
                                    DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color:
                                            Color.fromARGB(255, 229, 220, 41),
                                      ),
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          WavyAnimatedText("${data.length}"),
                                        ],
                                        isRepeatingAnimation: true,
                                        totalRepeatCount: 100,
                                      ),
                                    ),
                                  ],
                                ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    SlideRight(
                                      page: ClubsBureau(
                                        clubname: widget.name,
                                        clubimage: widget.imagepath3,
                                        leadersinfo: widget.bureauleaders,
                                        bureauimages: widget.bureauimages,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'About Us',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Lottie.asset("images/lottie_aboutus2.json",
                                        height: 30),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    SlideRight(
                                      page: ClubRoadMap(
                                        clubname: widget.name,
                                        clubid: widget.clubid,
                                        clubiduser: widget.clubiduser,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Lottie.asset("images/lottie_workshop.json",
                                        height: 40),
                                    const SizedBox(width: 7),
                                    const Text(
                                      'Planning',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 235, 227, 92),
                                      ),
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
                              color: Color.fromARGB(255, 214, 241, 170),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchUrl(widget.urlfb);
                                },
                                child: CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 205, 57),
                                    child:
                                        Lottie.asset("images/lottie_fb.json")),
                              ),
                              InkWell(
                                onTap: () {
                                  _launchUrl(widget.urlinstagram);
                                },
                                child: CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 205, 57),
                                    child: Lottie.asset(
                                        "images/lottie_instagram.json")),
                              ),
                              if (widget.name == "IEEE")
                                InkWell(
                                  onTap: () {
                                    _launchUrl(ieeeurl);
                                  },
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 205, 57),
                                    child: Lottie.asset(
                                      "images/lottie_web2.json",
                                      height: 45,
                                    ),
                                  ),
                                ),
                              InkWell(
                                onTap: () async {
                                  if (isInList) {
                                    Navigator.of(context).push(
                                      SlideRight(
                                        page: ClubWorkshops(
                                            name: widget.name,
                                            membersnumber: data.isEmpty
                                                ? 1
                                                : data.length,
                                            ispresidant: widget.clubiduser,
                                            id: widget.clubid),
                                      ),
                                    );
                                  } else if (data1.isNotEmpty) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: 'Invitation',
                                      titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 25,
                                      ),
                                      desc:
                                          'Your invitation was send to ${widget.name} admin. Please wait the confirmation ',
                                      descTextStyle:
                                          const TextStyle(fontSize: 18),
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: 'Access denied',
                                      titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 25,
                                      ),
                                      desc:
                                          'You don\'t have access to ${widget.name} workshops. Please send an invitation to ${widget.name} by adding it to your favorites!',
                                      descTextStyle:
                                          const TextStyle(fontSize: 18),
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 205, 57),
                                  child: Lottie.asset(
                                      "images/lottie_workshop.json"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isCurrentUserInList(String currentUserId) {
    for (QueryDocumentSnapshot document in data) {
      Map<String, dynamic> documentData =
          document.data() as Map<String, dynamic>;

      String userIdInDocument = documentData['idmember'];

      if (userIdInDocument == currentUserId) {
        return true;
      }
    }

    return false;
  }

  Future<void> addInvitationToFirestore(
    String clubid,
    String senderemail,
    String userclasse,
    String idsender,
    String sendername,
    String date,
    String clubname,
    String imageuser,
  ) async {
    try {
      setState(() {});
      await FirebaseFirestore.instance.collection('invitation').add(
        {
          'clubid': clubid,
          'senderemail': senderemail,
          'useryear': userclasse,
          'idsender': idsender,
          'sendername': sendername,
          'date': date,
          'clubname': clubname,
          'userpoints': 0,
          'userimage': imageuser.isEmpty
              ? "https://cdn-icons-png.freepik.com/512/180/180661.png"
              : imageuser,
          "etat": "En attente",
        },
      );

      setState(() {});
      showdialog(
          "Invitation",
          "Your invitation was send successffuly to ${widget.name}",
          DialogType.success);
    } catch (e) {
      showdialog("Error", "Please try again later.", DialogType.error);
    }
  }

  void showdialog(String title, String desc, DialogType type) {
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
      btnOkOnPress: () {
        if (!context.mounted) return;
        Navigator.pop(context, true);
      },
    ).show();
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error , Please try again later !"),
        ),
      );
    }
  }
}
