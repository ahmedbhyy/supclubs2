import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:supclubs/auth/sign_in.dart';
import 'package:supclubs/profilscreens/about_us.dart';
import 'package:supclubs/profilscreens/edit_profil.dart';
import 'package:supclubs/profilscreens/about_supcom.dart';
import 'package:supclubs/profilscreens/invitation_screens/member_invitaion.dart';

import 'package:supclubs/profilscreens/widget_profil/common_appbar.dart';
import 'package:supclubs/profilscreens/workshopsadmin/workshops_comingmembers.dart';
import 'package:supclubs/widgets/cards/card_profil.dart';
import 'package:supclubs/widgets/slides/slide_right.dart';

class ProfilScreen extends StatefulWidget {
  final bool isAdmin;
  final String clubpresidant;
  final String phone;
  final String year;
  final String clubnameuser;
  final String username;
  final String userid;
  final double appvote;
  const ProfilScreen(
      {super.key,
      required this.isAdmin,
      required this.clubpresidant,
      required this.phone,
      required this.year,
      required this.username,
      required this.appvote,
      required this.userid,
      required this.clubnameuser});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        children: [
          const AppBarProfil(
            title: "My Profil",
            lottie: "images/lottie_animation4.json",
          ),
          Lottie.asset("images/lottie_person.json", height: 230, repeat: false),
          const CardProfil(
            title: "Edit Profil",
            path: "images/lottie_arrow.json",
            child: EditProfil(),
          ),
          const CardProfil(
            title: "About Sup'com",
            path: "images/lottie_university.json",
            child: AboutSupcom(),
          ),
          CardProfil(
            title: "About Us",
            path: "images/lottie_aboutus2.json",
            child: AboutUs(appvote: widget.appvote, userid: widget.userid),
          ),
          widget.isAdmin
              ? CardProfil(
                  title: "Members Invitations",
                  path: "images/lottie_invitation.json",
                  child: MemberInvitation(clubid: widget.clubpresidant),
                )
              : Container(),
          widget.isAdmin
              ? CardProfil(
                  title: "Workshops Details",
                  path: "images/lottie_workshop.json",
                  child: WorkshopsDetailsPresidant(
                      clubnameuser: widget.clubnameuser),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                      SlideRight(page: const SignIn()), (route) => false);
                } catch (e) {
                  return;
                }
                try {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.disconnect();
                } catch (e) {
                  return;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log Out",
                    style: GoogleFonts.abel(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red,
                        fontStyle: FontStyle.italic),
                  ),
                  Lottie.asset("images/lottie_logout.json",
                      height: 60, repeat: false),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
